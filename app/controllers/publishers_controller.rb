class PublishersController < ApplicationController
  before_action :set_publisher, only: %i[ show edit update destroy ]
  before_action :set_publishers, only: %i[index]

  # GET /publishers or /publishers.json
  def index
    respond_to do |format|
      format.html { }
      format.turbo_stream { }
    end
  end

  # GET /publishers/1 or /publishers/1.json
  def show
  end

  # GET /publishers/new
  def new
    @publisher = Publisher.new
  end

  # GET /publishers/1/edit
  def edit
  end

  # POST /publishers or /publishers.json
  def create
    @publisher = Publisher.new(publisher_params)

    respond_to do |format|
      if @publisher.save
        format.html { redirect_to publisher_url(@publisher), notice: "Publisher was successfully created." }
        format.json { render :show, status: :created, location: @publisher }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publishers/1 or /publishers/1.json
  def update
    respond_to do |format|
      if @publisher.update(publisher_params)
        format.html { redirect_to publisher_url(@publisher), notice: "Publisher was successfully updated." }
        format.json { render :show, status: :ok, location: @publisher }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /publishers/1 or /publishers/1.json
  def destroy
    @publisher.destroy!

    respond_to do |format|
      format.html { redirect_to publishers_url, notice: "Publisher was successfully destroyed." }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_publisher
    @publisher = Publisher.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def publisher_params
    params.require(:publisher).permit(:name, works_attributes: [:id, :_destroy])
  end

  def set_publishers
    valid_order_params = ["name", "works_count"]
    valid_dir_params = ["asc", "desc"]

    order_param = params["order"].presence
    order_arg = (valid_order_params & [order_param])[0] || :name

    dir_param = params["dir"].presence
    dir_arg = (valid_dir_params & [dir_param])[0] || :asc

    order_param = "#{order_arg} #{dir_arg.upcase}"
    order_params = [order_param]
    order_params << "name ASC" unless order_arg == "name"

    @publishers = Publisher.all.order(*order_params)
  end
end
