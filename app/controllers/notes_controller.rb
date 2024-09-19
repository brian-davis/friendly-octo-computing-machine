class NotesController < ApplicationController
  before_action :set_note, only: %i[show edit update destroy]
  before_action :set_notable

  # GET /notes or /notes.json
  def index
    @notes = @notable.notes
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = @notable.notes.build
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = @notable.notes.build(note_params)

    respond_to do |format|
      if @note.save
        format.html {
          redirect_to([@notable, @note], notice: "Note was successfully created.")
        }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html {
          redirect_to([@notable, @note], notice: "Note was successfully updated.")
        }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy!
    respond_to do |format|
      format.html {
        redirect_to([@notable, @note], notice: "Note was successfully destroyed.")
      }
      format.json { head :no_content }
    end
  end

private
  def set_notable
    @notable = if params[:work_id].present?
      @work = Work.find(params[:work_id]) 
    elsif params[:producer_id]
      @producer = Producer.find(params[:producer_id]) 
    end
  end

  def set_note
    @note = Note.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def note_params
    params.require(:note).permit(:text, :notable_id, :notable_type)
  end
end
