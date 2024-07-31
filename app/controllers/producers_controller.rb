class ProducersController < ApplicationController
  before_action :set_producer, only: %i[ show edit update destroy ]
  before_action :set_producer_options, only: %i[new]
  before_action :set_work_options, only: %i[ new edit ]

  # GET /producers or /producers.json
  def index
    @producers = Producer.all
  end

  # GET /producers/1 or /producers/1.json
  def show
  end

  # GET /producers/new
  def new
    @producer = Producer.new

    respond_to do |format|
      format.html
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
        format.html { render :new, status: :unprocessable_entity }
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
        format.html { render :edit, status: :unprocessable_entity }
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

    def set_producer_options
      @producer_options = Producer.order(:name).pluck(:name).uniq
    end

    def set_work_options
      @work_options = Work.order(:title).pluck(:title).uniq
    end

    # Only allow a list of trusted parameters through.
    def producer_params
      params.require(:producer).permit(:name, work_attributes: [:title])
    end
end
