class WorksController < ApplicationController
  before_action :set_work, only: %i[show edit update destroy]
  before_action :build_or_set_work, only: %i[
    build_producer select_producer build_publisher select_publisher build_tag select_tag
  ]
  before_action :set_form_options, only: %i[new edit]

  # GET /works or /works.json
  def index
    @works = Work.all.order(:title)
    @works_count = Work.count
    @untagged_count = Work.untagged.count

    respond_to do |format|
      # initial
      format.html {
        @tags_cloud = Work.tags_cloud.sort_by { |k, v| v * -1 } # most popular first
        render("index")
      }

      # filter
      format.turbo_stream {
        @works = filtered_works(params)
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

  def filtered_works(params)
    if params["tag"] == "untagged"
      Work.untagged.order(:title)
    elsif params["tag"].in?(Work.all_tags)
      Work.all.with_any_tags([params["tag"]]).order(:title)
    elsif params["tag"] == "all" || params["tag"].blank?
      Work.all.order(:title)
    else
      Work.none
    end
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
        :role,
        :_destroy,
        :producer_id,
        producer_attributes: [:name]
      ]
    )


    permitted_params[:tags] ||= [] # always over-write (destructive)
    permitted_params[:tags].delete("") # ignore empty form data
    permitted_params
  end
end