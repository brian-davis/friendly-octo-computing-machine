class WorksController < ApplicationController
  before_action :set_work, only: %i[show edit update destroy]
  before_action :build_or_set_work, only: %i[build_producer select_producer]
  before_action :set_producer_options, only: %i[new edit]
  before_action :set_work_and_work_producers, only: %i[new edit]

  # GET /works or /works.json
  def index
    @works = Work.all
  end

  # GET /works/1 or /works/1.json
  def show
    @producer_credits = @work.work_producers.includes(:producer).pluck(:role, :name)
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
          set_work_and_work_producers
          set_producer_options

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
          set_work_and_work_producers
          set_producer_options

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

  def set_work_and_work_producers
    @work ||= Work.new
    @work_producers = @work.work_producers.includes(:producer)
  end

  def set_producer_options
    @producer_options = Producer.order(:name).pluck(:name, :id).uniq
  end

  def build_or_set_work
    @work = Work.find_by(id: params[:work_id]) || Work.new
  end

  def work_params
    params.require(:work).permit(:title, work_producers_attributes: [
      :id,
      :role,
      :_destroy,
      :producer_id,
      producer_attributes: [:name]
    ])
  end
end