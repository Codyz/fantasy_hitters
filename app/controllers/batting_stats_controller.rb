class BattingStatsController < ApplicationController 
	def index
		if params[:pos]
			@batting_stats = BattingStat.all.select {|b_hash| b_hash.player.pos == params[:pos].to_i}
		else
			@batting_stats = BattingStat.all
		end
	end
end