class QuotesController < ApplicationController
  before_action :set_work, except: %i[general_index]
  before_action :set_quote, only: %i[ show edit update destroy ]
  before_action :filter_and_sort_quotes, only: %i[index general_index]

  # GET /quotes or /quotes.json
  def index
    respond_to do |format|
      format.html { }
      format.turbo_stream { }
    end
  end

  def general_index
    respond_to do |format|
      format.html { }
      format.turbo_stream { }
    end
  end

  # GET /quotes/1 or /quotes/1.json
  def show
  end

  # GET /quotes/new
  def new
    @quote = @work.quotes.build
  end

  # GET /quotes/1/edit
  def edit
  end

  # POST /quotes or /quotes.json
  def create
    @quote = @work.quotes.build(quote_params)

    respond_to do |format|
      if @quote.save
        format.html {
          redirect_to work_quotes_url(@work), notice: "Quote was successfully created."
        }
        format.json { render :show, status: :created, location: @quote }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotes/1 or /quotes/1.json
  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to work_quotes_url(@work), notice: "Quote was successfully updated." }
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1 or /quotes/1.json
  def destroy
    @quote.destroy!

    respond_to do |format|
      format.html { redirect_to work_quotes_url(@work), notice: "Quote was successfully destroyed." }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_work
    @work = Work.find(params[:work_id])
  end

  def set_quote
    @quote = @work.quotes.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def quote_params
    params.require(:quote).permit(:work_id, :page, :section, :text)
  end

  def filter_and_sort_quotes
    if action_name == "general_index"
      # top-level access.  search across all works.  match by work name or author name

      @quotes = Quote.all
      if params["search_term"].present?
        term = ActiveRecord::Base::sanitize_sql(params["search_term"])
        quote_ids1 = Quote.search_text(term).ids
        quote_ids2 = Quote.joins(work: :producers).where(
          "producers.name LIKE '#{term}%' OR works.title LIKE '#{term}%'"
        ).ids # can't do `.or()` here
        full_ids = (quote_ids1 + quote_ids2).uniq
        @quotes = Quote.where({ id: full_ids }).includes(:work)
      end
    elsif @work
      # nested resource index

      @quotes = @work.quotes.all
      # filter by search term
      if params["search_term"].present?
        @quotes = @quotes.search_text(params["search_term"]).unscope(:order)
      end
    else
      raise("unauthorized")
    end
  end
end
