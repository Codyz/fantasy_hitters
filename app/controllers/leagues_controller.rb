class LeaguesController < ApplicationController
	before_filter :authenticate_user!

	def index
		@leagues = League.where(:user_id => current_user.id)
  end
  
  def show
  	@league = League.find(params[:id])

    @proj_vorp_seasons = @league.rank_all_vorp_seasons(false, true)
    @live_vorp_seasons = @league.rank_all_vorp_seasons(false, false)
  end
  
  def new
  	@league = League.new
  end
  
  def create
    @league = League.new(params[:league])
    
    if @league.save
      redirect_to :root
    else
      render :new
    end
  end
  
  def edit
    @league = League.find(params[:id])
  end
  
  def update
    @league = League.find(params[:id])
    
    if @league.update_attributes(params[:league])
      redirect_to league_url(@league)
    else
      render :edit
    end
  end
  
  def destroy
    League.find(params[:id]).destroy
    redirect_to :root
  end

end