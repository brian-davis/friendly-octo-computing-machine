class ProducersController < ApplicationController
  before_action :set_producer, only: %i[ show edit update destroy ]
  before_action :build_or_set_producer, only: %i[build_work select_work]
  before_action :set_form_options, only: %i[new edit]
  before_action :set_select_options, only: %i[index]
  before_action :filter_and_sort_producers, only: %i[index]

  # GET /producers or /producers.json
  def index
    respond_to do |format|
      format.html { }
      format.turbo_stream { }
    end
  end

  # GET /producers/1 or /producers/1.json
  def show
    @work_producers = @producer.work_producers.joins(:work).merge(Work.order_by_title).includes(:work)
  end

  # GET /producers/new
  def new
  end

  def build_work
    respond_to do |format|
      format.turbo_stream
    end
  end

  # join an existing Producer record to a Work record with new WorkProducer record
  def select_work
    @work = Work.find(params["work_id"])
    respond_to do |format|
      format.turbo_stream
    end
  end

  # GET /producers/1/edit
  def edit
  end

  # POST /producers or /producers.json
  def create
    @producer = Producer.new(producer_params)

    respond_to do |format|
      if @producer.save
        format.html { redirect_to producer_url(@producer), notice: "Producer was successfully created." }
        format.json { render :show, status: :created, location: @producer }
      else
        format.html {
          set_form_options
          render :new, status: :unprocessable_entity
        }

        format.turbo_stream {
          render "shared/form_errors", locals: { model_object: @producer }
        }

        format.json { render json: @producer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /producers/1 or /producers/1.json
  def update
    respond_to do |format|
      if @producer.update(producer_params)
        format.html { redirect_to producer_url(@producer), notice: "Producer was successfully updated." }
        format.json { render :show, status: :ok, location: @producer }
      else
        format.html {
          set_form_options
          render :edit, status: :unprocessable_entity
        }

        format.turbo_stream {
          render "shared/form_errors", locals: { model_object: @producer }
        }

        format.json { render json: @producer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /producers/1 or /producers/1.json
  def destroy
    @producer.destroy!

    respond_to do |format|
      format.html { redirect_to producers_url, notice: "Producer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

private
  # :show, :edit, :update, :destroy
  def set_producer
    @producer = Producer.find(params[:id])
  end

  # :index
  def set_select_options
    @select_options = [
      ["Name ▲", "full_name-asc"],
      ["Name ▼", "full_name-desc"],
      ["works count ▲", "works_count-asc"],
      ["works count ▼", "works_count-desc"]
    ]
  end

  # :index
  def filter_and_sort_producers
    @producers = ProducerFilter[params]
  end

  # :new, :edit
  def set_form_options
    @producer ||= Producer.new
    @work_producers = @producer.work_producers.includes(:work)

    @nationality_options = helpers.strict_datalist_options(Producer.nationality_options)
    @work_options = helpers.strict_options(Work.title_options)
  end

  # :build_work, :select_work
  def build_or_set_producer
    @producer = Producer.find_by(id: params[:producer_id]) || Producer.new
  end

  def producer_params
    params.require(:producer).permit(
      :custom_name,
      :forename,
      :middle_name,
      :surname,
      :foreign_name,
      :full_name,

      :year_of_birth,
      :year_of_death,
      :bio_link,
      :nationality,

      work_producers_attributes: [
        :id,
        :role,
        :_destroy,
        :work_id,
        work_attributes: [:title]
      ]
    )
  end
end
