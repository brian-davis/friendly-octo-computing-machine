class ProducersController < ApplicationController
  before_action :set_producer, only: %i[ show edit update destroy ]
  before_action :build_or_set_producer, only: %i[build_work select_work]
  before_action :set_form_options, only: %i[new edit]
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
    @work_producers = @producer.work_producers.includes(:work).order("works.title ASC")
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
  # Use callbacks to share common setup or constraints between actions.
  def set_producer
    @producer = Producer.find(params[:id])
  end

  def filter_and_sort_producers
    @producers = Producer.all

    # filter by search term
    if params["search_term"].present?
      term = ActiveRecord::Base::sanitize_sql(params["search_term"])
      @producers = @producers.search_name(term).unscope(:order)
    end
    # order by dropdown selection
    valid_order_params = ["full_name", "works_count"]
    valid_dir_params = ["asc", "desc"]

    order_param = params["order"].presence
    order_arg = (valid_order_params & [order_param])[0]

    dir_param = params["dir"].presence
    dir_arg = (valid_dir_params & [dir_param])[0] || :asc

    default_query_options = {
      :full_name => :asc
    }
    new_query_options = {}
    new_query_options[order_arg.to_sym] = dir_arg.to_sym if order_arg

    query_options = default_query_options.merge(new_query_options)

    @producers = @producers.order_by_full_name(query_options)
  end

  def set_form_options
    @producer ||= Producer.new
    @work_producers = @producer.work_producers.includes(:work)
    @work_options = Work.title_options
    @nationality_options = Producer.nationality_options
  end

  # TODO: combine with set_form_options
  def build_or_set_producer
    @producer = Producer.find_by(id: params[:producer_id]) || Producer.new
  end

  def producer_params
    params.require(:producer).permit(
      :custom_name,
      :given_name,
      :middle_name,
      :family_name,
      :foreign_name,
      :full_name,

      :birth_year,
      :death_year,
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
