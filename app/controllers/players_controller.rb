class PlayersController < ApplicationController
	def index
		if params[:search]
			@players = Player.search(params[:search])
		elsif params[:pos]
			@players = Player.where(:pos => params[:pos])
			@pos = params[:pos]
		else
			@players = Player.all
		end
	end

	def show
		@player = Player.find(params[:id])
	end
end