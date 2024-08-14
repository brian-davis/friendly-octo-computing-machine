class WorksController < ApplicationController
  before_action :set_work, only: %i[show edit update destroy]
  before_action :build_or_set_work, only: %i[
    build_producer select_producer build_publisher select_publisher build_tag select_tag
  ]
  before_action :set_form_options, only: %i[new edit]

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
  end

  # GET /works/new
  def new
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
      format.html { redirect_to works_url, notice: "Work was successfully destroyed." }
      format.json { head :no_content }
    end
  end

private
  def set_work
    @work = Work.find(params[:id])
  end

  def set_form_options
    @work ||= Work.new
    @work_producers = @work.work_producers.includes(:producer)
    @producer_options = Producer.order(:name).pluck(:name, :id).uniq
    @publisher_options = Publisher.order(:name).pluck(:name, :id).uniq
    @tag_options = Work.all_tags.sort
  end

  # TODO: combine with set_form_options
  def build_or_set_work
    @work = Work.find_by(id: params[:work_id]) || Work.new
  end

  def work_params
    permitted_params = params.require(:work).permit(
      :title,
      :subtitle,
      :alternate_title,
      :foreign_title,
      :year_of_composition,
      :year_of_publication,
      :language,
      :original_language,
      :publisher_id,
      :_clear_publisher,
      tags: [],
      publisher_attributes: [:name],
      work_producers_attributes: [
        :id,
        :_destroy,
        :role,
        :producer_id,
        producer_attributes: [:name]
      ],
      quotes_attributes: [
        :id,
        :_destroy,
        :text,
        :page,
        :section
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

    # filter by search term
    if params["search_term"].present?
      term = ActiveRecord::Base::sanitize_sql(params["search_term"])
      @works = @works.search_title(term).unscope(:order)
    end

    # order by dropdown selection
    valid_order_params = ["title", "year"]
    valid_dir_params = ["asc", "desc"]
    order_param = params["order"].presence
    order_arg = (valid_order_params & [order_param])[0] || :title
    dir_param = params["dir"].presence
    dir_arg = (valid_dir_params & [dir_param])[0] || :asc
    @order_value = [order_arg, dir_arg].join("-");
    order_arg = "year_of_composition" if order_arg.to_s == "year"
    order_param = "#{order_arg} #{dir_arg.upcase}"
    order_params = [order_param]
    order_params << "title ASC" unless order_arg == "title"
    order_params.uniq!

    @works = @works.order(*order_params)
  end
end