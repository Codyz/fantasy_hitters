class BattingProjectionsController < ApplicationController 
	def index
		if params[:pos]
			@players = Player.all_position_members(params[:pos])
		else
			@players = Player.all
		end
	end
end