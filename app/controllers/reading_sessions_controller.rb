class ReadingSessionsController < ApplicationController
  before_action :set_work
  before_action :set_reading_session, only: %i[ show edit update destroy ]

  # GET /reading_sessions or /reading_sessions.json
  def index
    @reading_sessions = @work.reading_sessions.order(:started_at)
  end

  # GET /reading_sessions/1 or /reading_sessions/1.json
  def show
  end

  # GET /reading_sessions/new
  def new
    @reading_session = ReadingSession.new
  end

  # GET /reading_sessions/1/edit
  def edit
  end

  # POST /reading_sessions or /reading_sessions.json
  def create
    @reading_session = @work.reading_sessions.new(reading_session_params)

    respond_to do |format|
      if @reading_session.save
        format.html { redirect_to work_reading_session_url(@work, @reading_session), notice: "Reading session was successfully created." }
        format.json { render :show, status: :created, location: @reading_session }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reading_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reading_sessions/1 or /reading_sessions/1.json
  def update
    respond_to do |format|
      if @reading_session.update(reading_session_params)
        format.html { redirect_to work_reading_session_url(@work, @reading_session), notice: "Reading session was successfully updated." }
        format.json { render :show, status: :ok, location: @reading_session }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reading_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reading_sessions/1 or /reading_sessions/1.json
  def destroy
    @reading_session.destroy!

    respond_to do |format|
      format.html { redirect_to work_reading_sessions_url(@work), notice: "Reading session was successfully destroyed." }
      format.json { head :no_content }
    end
  end

private
  def set_work
    @work = Work.find(params["work_id"])
  end

  def set_reading_session
    @reading_session = ReadingSession.find(params[:id])
  end

  def reading_session_params
    params.require(:reading_session).permit(:started_at, :ended_at, :work_id, :pages)
  end
end
