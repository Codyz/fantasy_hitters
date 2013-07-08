class NotesController < ApplicationController
	before_filter :authenticate_user!

	def index
		@notes = Note.where(:user_id => current_user.id)
  end
  
  def show
  	@note = Note.find(params[:id])
  end
  
  def new
  	@note = Note.new(:player_id => params[:player_id])
  end
  
  def create
    @note = Note.new(params[:note])
    
    if @note.save
      redirect_to :root
    else
      render :new
    end
  end
  
  def edit
    @note = Note.find(params[:id])
  end
  
  def update
    @note = Note.find(params[:id])
    
    if @note.update_attributes(params[:note])
      redirect_to note_url(@note)
    else
      render :edit
    end
  end
  
  def destroy
    Note.find(params[:id]).destroy
    redirect_to :root
  end

end