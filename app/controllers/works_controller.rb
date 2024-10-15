class WorksController < ApplicationController
  before_action :set_work, only: %i[show edit update destroy]
  before_action :build_or_set_work, only: %i[
    build_producer select_producer build_publisher select_publisher build_tag select_tag build_parent select_parent clone_work
  ]
  before_action :set_form_options, only: %i[new edit clone_work]
  before_action :set_select_options, only: %i[index]
  before_action :set_tags_cloud, only: %i[index]
  before_action :filter_and_sort_works, only: %i[index]

  # GET /works or /works.json
  def index
    respond_to do |format|
      format.html {}

      # stimulus controller will make this request via JS
      format.turbo_stream {}
    end
  end

  # GET /works/1 or /works/1.json
  def show
    @work_producers = @work.work_producers.includes(:producer)
    @children = @work.children.joins(:producers).includes(:producers)
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
    @tag = ''
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

  def clone_work
    # copy @work attributes to new object
    # make @work_producer ids blank
    new_attrs = @work.attributes.except("created_at", "updated_at", "id", "searchable")
    new_attrs["title"] += " CLONE"
    @work = Work.new(new_attrs)
    @work_producers = @work_producers.map { |wp|
      new_attrs = wp.attributes.except("work_id","id", "created_at", "updated_at")
      WorkProducer.new(new_attrs)
    }
  end

private
  # :show, :edit, :update, :destroy
  def set_work
    @work = Work.find(params[:id])
  end

  # :new, :edit
  def set_form_options
    @work ||= Work.new
    @work_producers = @work.work_producers.includes(:producer)
    @publisher = @work.publisher
    @language_options = helpers.strict_datalist_options(Work.language_options)
    @parent_options = helpers.strict_options(Work.parent_options(@work))
    @producer_options = helpers.strict_options(Producer.name_options)
    @publisher_options = helpers.strict_options(Publisher.name_options)
    @publishing_format_options = helpers.strict_options(Work.publishing_format_options)
    @tag_options = helpers.strict_options(Work.tag_options)
    @clone_options = helpers.strict_options(Work.clone_options)
  end

  # :index
  def set_select_options
    @sort_options = [
      ["Title ▲", "title-asc"],
      ["Title ▼", "title-desc"],
      ["Year ▲", "year-asc"],
      ["Year ▼", "year-desc"],
      ["Rating ▲", "rating-asc"],
      ["Rating ▼", "rating-desc"]
    ]
    @publishing_format_options = Work.publishing_format_options
    @language_options = Work.language_options(unspecified: true)
    @accession_options = [:collection, :wishlist].map { |opt| [opt.to_s.humanize, opt] }
    @status_options = [:read, :unread].map { |opt| [opt.to_s.humanize, opt] }
  end

  # :build_*, :select_*
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
      :publishing_format,
      :publisher_id,
      :parent_id,
      :rating,
      :_clear_publisher,
      :_clear_parent,
      :date_of_accession,
      :date_of_completion,
      :accession_note,
      tags: [],
      publisher_attributes: [
        :name,
        :location
      ],
      parent_attributes: [
        :title,
        :publishing_format
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

  # :index
  def filter_and_sort_works
    @works = WorkFilter[params]
  end

  # :index
  def set_tags_cloud
    @tags_cloud = Work.extended_tags_cloud
  end
end