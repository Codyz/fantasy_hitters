class League < ActiveRecord::Base
	attr_accessible :name, :num_c, :num_1b, :num_2b, :num_3b, :num_ss, :num_lf, :num_cf, :num_rf, :num_dh, :num_teams, :user_id

	validates :num_c, :num_1b, :num_2b, :num_3b, :num_ss, :num_lf, :num_cf, :num_rf, :num_dh, :num_teams, :presence => true
	validates :name, :uniqueness => {:scope => :user_id,
	 :message => "Your league name must be unique"}



	# these are numbers that depend on a couple of years worth of an individual league's empirical
	# data. For the meantime I'm hardcoding this in. Finding them requires a lot of work and 
	# specific data that the user's unlikely to have. 

	PTS_PER_GAP = {
		:r => 15,
		:rbi => 14,
		:hr => 6,
		:sbn => 5,
		:ba => 0.00199,
		:obp => 0.0026,
		:ops => 0.00603,
	}

		POSITION_NUMBERS = {
		:num_c => 2,
		:num_1b => 3,
		:num_2b => 4,
		:num_3b => 5,
		:num_ss => 6,
		:num_lf => 7,
		:num_cf => 8,
		:num_rf => 9,
		:num_dh => 10,
	}

	HEADERS = [:name, :r, :rbi, :hr, :sbn, :ba, :obp, :ops, :total]

	POSITION_NAMES = POSITION_NUMBERS.invert

	# Display methods
	def League.headers 
		HEADERS
	end

	def row(h)
		[h[:r],h[:rbi] ,h[:hr],h[:sbn], h[:ba], h[:obp], h[:ops], h[:total]]
	end


	# CLASS METHODS

	def League.position_nums(league_parameter)
		POSITION_NUMBERS(league_parameter)
	end

	# INSTANCE METHODS

	# league lineup, composition methods, etc

	# takes a number
	def num_players_at_position(pos)
		pos_name = POSITION_NAMES[pos].to_s
		self.send(pos_name) * self.num_teams 
	end

	def num_players_on_team
		self.num_c + self.num_1b + self.num_2b + self.num_3b + self.num_ss + self.num_lf + self.num_cf + self.num_rf + self.num_dh
	end


	# collective player ranking methods 


	def rank_all_vals(pos=false, proj=true)
		if pos 
			players = Player.all_position_members(pos)
		else
			players = Player.all 
		end

		if proj
			all_stats = players.map {|player| player.batting_projections.first}
		else
			all_stats = []
			players.each do |player|
				next unless player.batting_stat
				all_stats << player.batting_stat
			end
		end

		all_vals = all_stats.map {|all_stat| self.value_per_game(all_stat)}

		return rank_vals(all_vals) 
	end

	def rank_all_vorp_games(pos=false, proj=true)
		if pos 
			players = Player.all_position_members(pos)
			replacement_players = {pos => self.replacement_value_per_game(pos, proj)}
		else
			players = Player.all 
			replacement_players = {}
			2.upto(10) do |i|
				replacement_players[i] = self.replacement_value_per_game(i, proj)
			end
		end

		if proj
			all_stats = players.map {|player| player.batting_projections.first}
		else
			all_stats = []
			players.each do |player|
				next unless player.batting_stat
				all_stats << player.batting_stat
			end
		end

		all_vals = all_stats.map do |all_stat| 
			player_position = all_stat.player.pos
			next unless [2,3,4,5,6,7,8,9,10].include?(player_position)
			self.vorp_per_game(all_stat, proj, replacement_players[player_position])
		end

		return rank_vals(all_vals)
	end

	def rank_all_vorp_seasons(pos=false, proj=true)
		vorp_game_vals = rank_all_vorp_games(pos, proj)
		all_vals = [] 
		vorp_game_vals.each do |vorp|
			player = Player.find(vorp[:player_id])
			vorp.delete(:player_id)

			games = proj ? player.batting_projections.first.gp : player.batting_stat.gp

			season_total_hash = Hash[vorp.keys.zip(vorp.map {|k, v| v * games })]
			season_total_hash[:player_id] = player.id 
			all_vals << season_total_hash 
		end

		return rank_vals(all_vals)
	end 

	# individual player rank methods


	def value_per_game(stats)
		cats = PTS_PER_GAP.keys
		return unless stats
		player_id = stats.player_id
		stats = stats.attributes
		result = Hash.new(0)
		cats.each do |cat|
			if [:r, :rbi, :sbn, :hr].include?(cat)
				result[cat] = (stats[cat.to_s] / PTS_PER_GAP[cat]) / stats['gp']
			else
				next unless stats[cat.to_s]
				result[cat] = (stats[cat.to_s] / PTS_PER_GAP[cat]) / (self.num_players_on_team * 162.0)
			end
		end

		result[:total] = result.values.inject(0) {|total, i| total + i }
		result[:player_id] = player_id
		return result
	end 

	def vorp_per_game(player_stats, proj=true, replacement_per_game) 
		player_pos = player_stats.player.pos
		player_per_game = value_per_game(player_stats)

		player_id = player_per_game[:player_id] # temporarily store the player_id, then delete. Makes looping through stats easier.
		player_per_game.delete(:player_id)

		result = Hash.new(0)
		player_per_game.each do |k1, v1| 
			next unless replacement_per_game
			replacement_per_game.each do |k2, v2|
				result[k1] = player_per_game[k1] - replacement_per_game[k1]
			end
		end
		result[:player_id] = player_id
		return result 
	end


	# position here must be a number, not the name of the position
	def replacement_value_per_game(pos, proj=true)
		players = Player.all_position_members(pos)

		if proj
			stats = []
			players.each do |player|
				next unless player.batting_projections.first
				stats << player.batting_projections.first
			end
		else
			stats = []
			players.each do |player|
				next unless player.batting_stat
				stats << player.batting_stat
			end
		end


		vals = stats_to_vals(stats)
		ranks = rank_vals(vals)

		# this is a rough_value, accounting for injuries, benches, etc.
		replacement_index = (self.num_players_at_position(pos) * 1.2).round
		return ranks[replacement_index]
	end

	def stats_to_vals(arr_stats)
		arr_stats.map {|stats| self.value_per_game(stats)}
	end

	# ranks accepts an array of valuations, and orders it by total value
	def rank_vals(valuations)
		# count = 0
		# p valuations.size
		# valuations.each do |valuation| 
		# 	count += 1
		# 	ap count 
		# 	ap valuation if (count.between?(595, 605))
		# end
		valuations.sort_by {|k| k[:total] || -30 }.reverse
	end

end