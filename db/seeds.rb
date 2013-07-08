# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


path_1 = Rails.root.join("db", "data", "steamer_hitting_2013.xls")
path_2 = Rails.root.join("db", "data", "zips_hitting_2013.xls")
S = Roo::Excel.new(path_1.to_s)
Z = Roo::Excel.new(path_2.to_s)

# seed the players, teams, and circuits with zips 



circuits = ["al", "nl"]

# these names are idiotic. NYA? Come on, ZIPS! 
ZIPS_TEAM_NAME_NUMS = {
	"BOS" => 1,
	"TB" => 2,
	"TOR" => 3,
	"NYA" => 4,
	"BAL" => 5,
	"DET" => 6,
	"KC" => 7,
	"CLE" => 8,
	"MIN" => 9,
	"CHA" => 10,
	"LAA" => 11,
	"TEX" => 12,
	"HOU" => 13,
	"OAK" => 14,
	"SEA" => 15,
	"ATL" => 16,
	"WAS" => 17,
	"NYN" => 18,
	"MIA" => 19,
	"PHI" => 20,
	"CIN" => 21,
	"STL" => 22,
	"PIT" => 23,
	"MIL" => 24,
	"CHN" => 25,
	"ARI" => 26,
	"SF" => 27,
	"COL" => 28,
	"LAD" => 29,
	"SD" => 30
}

ZIPS_PLAYER_ATTRIBUTES = {
	1 => :name,
	2 => :team,
	4 => :age,
	5 => :pos_name,
}

ZIPS_TEAM_ATTRIBUTES = {
	2 => :name 
}

ZIPS_BATTING_ATTRIBUTES = {
	1 => :name, 
	2 => :team_name,
	6 => :ba,
	7 => :obp,
	8 => :slg,
	9 => :gp,
	10 => :ab,
	11 => :r,
	12 => :hits,
	13 => :doubles,
	14 => :triples,
	15 => :hr,
	16 => :rbi,
	17 => :bb,
	18 => :k,
	19 => :hbp,
	20 => :sb,
	21 => :cs 
}

# steamer_batting_attributes = {
# 	8 => :gp,
# 	9 => :pa,
# 	12 => :bb,
# 	13 => :k,
# 	14 => :hbp,
# 	18 => :ab,
# 	19 => :hits,
# 	20 => :singles,
# 	21 => :doubles,
# 	22 => :triples,
# 	23 => :hr,
# 	24 => :ba,
# 	25 => :obp,
# 	26 => :slg,
# 	28 => :sb,
# 	29 => :cs,
# 	30 => :r,
# 	31 => :rbi
# }



def read_zips(attributes)
	result = []

	(2..Z.last_row).each do |i|
	  row = Z.row(i)
	  atts = {}

	  attributes.keys.each do |j|
	  	att = attributes[j]
	  	value = row[j - 1]
	  	value.downcase! if value.is_a?(String)
	  	atts[att] = value
	  end

	  result << atts 
	end
	return result  
end

players = read_zips(ZIPS_PLAYER_ATTRIBUTES)
teams = read_zips(ZIPS_TEAM_ATTRIBUTES).uniq!
zips_batting_projections = read_zips(ZIPS_BATTING_ATTRIBUTES)


# seed methods

def seed_teams(teams)
	teams.each do |team| 
		team[:circuit] = ZIPS_TEAM_NAME_NUMS[team[:name].to_s.upcase] <= 15 ? "al" : "nl"
		Team.find_or_create_by_name!(team[:name], team)
	end
end

def seed_players(players)
	players.each do |player|
		player[:fname], player[:lname] = player[:name].split
		pos_nums = Player.position_names.invert
		player[:pos] = pos_nums[player[:pos_name]]
		player.delete(:pos_name)
		player[:team_id] = Team.find_by_name(player[:team]).id
		player.delete(:team)
		player[:batsman] = true
		Player.create!(player)
	end 
end

def seed_zips_batting_projections(projections) 
	projections.each do |projection|
		projection[:ops] = projection[:slg] + projection[:obp]
		projection[:pa] = projection[:ab] + projection[:hbp] + projection[:bb]
		projection[:sbn] = projection[:sb] - projection[:cs]
		projection[:singles] = projection[:hits] - projection[:triples] - projection[:doubles] - projection[:hr]

		team_id = Team.find_by_name(projection[:team_name]).id
		projection[:player_id] = Player.find_by_name_and_team_id(projection[:name], team_id).id 
		projection.delete(:name)
		projection.delete(:team_name)
		projection[:company] = "zips"
		BattingProjection.create!(projection)
	end
end

# seed the teams and players

seed_teams(teams)
seed_players(players)

# seed the projections

seed_zips_batting_projections(zips_batting_projections)











