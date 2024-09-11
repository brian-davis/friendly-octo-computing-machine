class WorksController < ApplicationController
  before_action :set_work, only: %i[show edit update destroy]
  before_action :build_or_set_work, only: %i[
    build_producer select_producer build_publisher select_publisher build_tag select_tag build_parent select_parent
  ]
  before_action :set_form_options, only: %i[new edit]
  before_action :set_select_options, only: %i[index]
  before_action :filter_and_sort_works, only: %i[index]

  # GET /works or /works.json
  def index
    respond_to do |format|
      # initial
      format.html {
        @works_count = Work.count
        @untagged_count = Work.untagged.count
        @tags_cloud = Work.tags_cloud.sort_by { |k, v| v * -1 } # most popular first
        render("index")
      }

      # filter, sort
      format.turbo_stream {
        render("index")
      }
    end
  end

  # GET /works/1 or /works/1.json
  def show
    @work_producers = @work.work_producers.includes(:producer)
    @bibliography = Citation::Bibliography.new(@work).entry
  end

  # GET /works/new
  def new
  end

  # GET /works/1/edit
  def edit
  end

  # POST /works or /works.json
  def create
    @work = Work.new(work_params)

    respond_to do |format|
      if @work.save
        format.html { redirect_to work_url(@work), notice: "Work was successfully created." }
        format.json { render :show, status: :created, location: @work }
      else
        format.html {
          set_form_options
          render :new, status: :unprocessable_entity
        }

        format.turbo_stream {
          render "shared/form_errors", locals: { model_object: @work }
        }

        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /works/1 or /works/1.json
  def update
    respond_to do |format|
      if @work.update(work_params)
        format.html { redirect_to work_url(@work), notice: "Work was successfully updated." }
        format.json { render :show, status: :ok, location: @work }
      else

        format.html {
          set_form_options
          render :edit, status: :unprocessable_entity
        }

        format.turbo_stream {
          render "shared/form_errors", locals: { model_object: @work }
        }

        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /works/1 or /works/1.json
  def destroy
    @work.destroy!

    respond_to do |format|
      format.html {
      redirect_to(
        works_url, {
          notice: "Work was successfully destroyed."
        })
      }
      format.json { head :no_content }
    end
  end

  def build_producer
    respond_to do |format|
      format.turbo_stream
    end
  end

  # join an existing Producer record to a Work record with new WorkProducer record
  def select_producer
    @producer = Producer.find(params["producer_id"])
    respond_to do |format|
      format.turbo_stream
    end
  end

  def build_tag
    respond_to do |format|
      format.turbo_stream
    end
  end

  # join an existing Producer record to a Work record with new WorkProducer record
  def select_tag
    @tag = params["tag"]
    respond_to do |format|
      format.turbo_stream
    end
  end

  def build_publisher
    @tag = String.new
    respond_to do |format|
      format.turbo_stream
    end
  end

  # join an existing Producer record to a Work record with new WorkProducer record
  def select_publisher
    @publisher = Publisher.find(params["publisher_id"])
    respond_to do |format|
      format.turbo_stream
    end
  end

  def build_parent
    @parent = @work.build_parent
  end

  def select_parent
    ids = Work.compilations.ids - [@work.id]
    @parent = Work.where(id: ids).find(params["parent_id"])
  end

private
  def set_work
    @work = Work.find(params[:id])
  end

  # _form
  def set_form_options
    @work ||= Work.new
    @work_producers = @work.work_producers.includes(:producer)

    @producer_options = Producer.name_options
    @publisher_options = Publisher.name_options

    @language_options = Work.language_options
    @parent_options = Work.parent_options(@work)
    @tag_options = Work.tag_options

    @format_options = Work.format_options
  end

  # index
  def set_select_options
    @sort_options = [
      ["Title ▲", "title-asc"],
      ["Title ▼", "title-desc"],
      ["Year ▲", "year-asc"],
      ["Year ▼", "year-desc"],
      ["Rating ▲", "rating-asc"],
      ["Rating ▼", "rating-desc"]
    ]
    @format_options = Work.format_options
    @language_options = Work.language_options(unspecified: true)
    @accession_options = [:collection, :wishlist].map { |opt| [opt.to_s.humanize, opt] }
    @status_options = [:read, :unread].map { |opt| [opt.to_s.humanize, opt] }
  end

  # TODO: combine with set_form_options
  def build_or_set_work
    @work = Work.find_by(id: params[:work_id]) || Work.new
  end

  def work_params
    permitted_params = params.require(:work).permit(
      :title,
      :subtitle,
      :supertitle,
      :alternate_title,
      :foreign_title,
      :year_of_composition,
      :year_of_publication,
      :language,
      :original_language,
      :custom_citation,
      :format,
      :publisher_id,
      :parent_id,
      :rating,
      :_clear_publisher,
      :_clear_parent,
      :date_of_accession,
      :date_of_completion,
      :accession_note,
      tags: [],
      publisher_attributes: [:name],
      parent_attributes: [
        :title,
        :format
      ],
      work_producers_attributes: [
        :id,
        :_destroy,
        :role,
        :producer_id,
        producer_attributes: [
          :custom_name,
          :forename,
          :middle_name,
          :surname,
          :foreign_name,
          :full_name
        ]
      ],
      quotes_attributes: [
        :id,
        :_destroy,
        :text,
        :page,
        :custom_citation
      ]
    )

    permitted_params[:tags] ||= [] # always over-write (destructive)
    permitted_params[:tags].delete("") # ignore empty form data
    permitted_params
  end

  def filter_and_sort_works
    # filter by tag
    @works = if params["tag"] == "untagged"
      Work.untagged
    elsif params["tag"].in?(Work.all_tags)
      Work.all.with_any_tags([params["tag"]])
    elsif params["tag"] == "all" || params["tag"].blank?
      Work.all
    else
      # ?tag=malicious
      Work.none
    end

    acc_param = params["accession"]
    valid_accession_params = ["collection", "wishlist"]
    if acc_param.in?(valid_accession_params)
      @works = @works.send(acc_param)
    end

    status_param = params["sts"]
    valid_status_params = ["read", "unread"]
    if status_param.in?(valid_status_params)
      @works = @works.send(status_param)
    end

    # filter by search term
    if params["search_term"].present?
      term = ActiveRecord::Base::sanitize_sql(params["search_term"])
      @works = @works.search_title(term).unscope(:order)
    end

    format_param = params["frmt"]
    valid_formats = Work.formats.keys
    if format_param.in?(valid_formats)
      @works = @works.where_format(format_param)
    end

    lang_param = params["lang"]
    if lang_param.in?(@language_options)
      @works = if lang_param == "[unspecified]"
        @works.where(language: nil)
      else
        @works.where(language: lang_param)
      end
    end

    # order by dropdown selection
    valid_order_params = ["title", "year", "rating"]
    valid_dir_params = ["asc", "desc"]
    order_param = params["order"].presence
    order_arg = (valid_order_params & [order_param])[0] || "title"
    order_arg = "UPPER(#{order_arg})"
    dir_param = params["dir"].presence
    dir_arg = (valid_dir_params & [dir_param])[0] || "asc"

    # always put unrated works at end
    order_arg = if order_arg == "rating" && dir_arg == "desc"
      "COALESCE(works.rating, -1)"
    elsif order_arg == "rating" && dir_arg == "asc"
      "COALESCE(works.rating, 9999999)"
    elsif order_arg == "year" && dir_arg == "desc"
      "COALESCE(year_of_composition, year_of_publication, -9999)"
    elsif order_arg == "year" && dir_arg == "asc"
      "COALESCE(year_of_composition, year_of_publication, 9999)"
    else
      order_arg
    end

    order_param = "#{order_arg} #{dir_arg.upcase}"
    order_params = [order_param]
    order_params << "UPPER(title) ASC" unless order_arg == "UPPER(title)" # secondary ordering
    order_params = order_params.uniq.join(", ") # secondary ordering

    # bullet disabled here
    @works = @works.order(Arel.sql(order_params)).includes(:parent).includes(:authors)
  end
end