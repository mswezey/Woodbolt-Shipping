class NotesController < ApplicationController
  before_filter :require_user
  def index
    if params[:shipment_id]
      @shipment = Shipment.find(params[:shipment_id])
      @notes = @shipment.notes.all
      respond_to do |format|
        format.html
        format.js
      end
    else
      @notes = Note.all
    end
  end
  
  def show
    @note = Note.find(params[:id])
  end
  
  def new
    @note = Note.new
  end
  
  def create
    @note = Note.new(params[:note])
    @note.user_id = current_user.id
    if @note.save
      respond_to do |format|
        format.html {
          flash[:notice] = "Successfully created note."
          redirect_to @note
        }
        format.js {
          @shipment = @note.shipment
        }
      end
    else
      render :action => 'new'
    end
  end
  
  def edit
    @note = Note.find(params[:id])
  end
  
  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(params[:note])
      flash[:notice] = "Successfully updated note."
      redirect_to @note
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    flash[:notice] = "Successfully destroyed note."
    redirect_to notes_url
  end
end
