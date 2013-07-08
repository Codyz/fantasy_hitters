# encoding=utf-8
require 'nokogiri'
require 'open-uri'


class BattingStat < ActiveRecord::Base
	attr_accessible :gp, :pa, :ab, :bb, :hbp, :k, :hits,
		:singles, :doubles, :triples, :hr, :ba, :obp, :slg, :ops, :sb,
		:cs, :sbn, :r, :rbi, :ppa, :player_id 



	validates :gp, :pa, :ab, :bb, :hbp, :k, :hits, :singles, :doubles, :triples,
		:hr, :ba, :obp, :ops, :sb, :cs, :sbn, :r, :rbi, :numericality => true

	belongs_to :player


	HEADERS = [:name, :gp, :pa, :ab, :bb, :hbp, :k, :hits,
		:singles, :doubles, :triples, :hr, :ba, :obp, :slg, :ops, :sb,
		:cs, :sbn, :r, :rbi]

	URL = "http://www.baseball-reference.com/leagues/MLB/2013-standard-batting.shtml"
	BR_HEADS = %w(rk name age team lg gp pa ab r hits doubles triples hr rbi sb cs bb k ba obp slg ops ops+ tb gdp hbp sh)

	DB_TEAM_NAMES = %w(ari atl bal bos chn cha cin cle col det hou kc laa lad mia
										 	mil min nyn nya oak phi pit sd sea sf stl tb tex tor was)

	BR_TEAM_NAMES = %w(ARI ATL BAL BOS CHC CHW CIN CLE COL DET HOU KCR LAA
											LAD MIA MIL MIN NYM NYY OAK PHI PIT SDP SEA SFG STL TBR
											TEX TOR WSN)

	def BattingStat.headers 
		HEADERS 
	end

	def row 
		[self.gp, self.pa, self.ab, self.bb, self.hbp, self.k, self.hits, self.singles, self.doubles,
			self.triples, self.hr, self.ba, self.obp, self.slg, self.ops, self.sb, self.cs, self.sbn, self.r, 
			self.rbi].map {|stat| stat.round(3)}
	end

	def rank_row 
		[self.r, self.hr, self.rbi, self.ba, self.obp,
			self.ops, self.sbn].map {|stat| stat.round(3)}
	end

	# baseball-reference stat scraping methods

	def BattingStat.grab_stats
		doc = Nokogiri::HTML(open(URL))
		rows = doc.css("#players_standard_batting tr")
		return rows
	end

	def BattingStat.parse_stats(rows)
		batting_stats = []

		rows[1..-1].each do |row|
			b_row = row.children.text.split
			next unless (b_row[0] =~ /\d/) # handles the buffer every 25 rows
			next unless ["AL", "NL"].include?(b_row[4])
			next unless BR_TEAM_NAMES.include?(b_row[3])
			b_row.each_index {|i| b_row[i] = b_row[i].to_f if (b_row[i] =~ /\d/)}
			b_hash = Hash[BR_HEADS.zip(b_row)]
			batting_stats << b_hash if b_hash["gp"].to_i > 10 # ditch players who don't play enough
		end

		# turn the strings to integers
		batting_stats.each do |b_hash|
			b_hash.values.each do |v|
				v = v.to_i if (v =~ /\d/)
			end
		end

		# get rid of crap players (those who don't have all stats)
		batting_stats.select! {|b_hash| b_hash.values.all? {|v| v != nil}}

		# remove non letters from names (i.e. asterisks and hashtags indicating injury status)
		batting_stats.each {|b_hash| b_hash["name"].gsub!(/\p{^Letter}/, ' ').strip! }

		return batting_stats
	end

	def BattingStat.clean_data(batting_stats)
		batting_atts = %w(gp pa ab bb hbp k hits singles doubles triples hr ba obp
									slg ops sb cs sbn r rbi player_id)


		team_name_dict = Hash[BR_TEAM_NAMES.zip(DB_TEAM_NAMES)]

		cleaned_batting_stats = []

		batting_stats.each do |batting_stat|
			cleaned_batting_hash = {}

			batting_atts.each do |att|
				cleaned_batting_hash[att] = batting_stat[att] if batting_stat[att]
			end

			# get the appropriate player from the database associated with these stats
			db_team_name = team_name_dict[batting_stat["team"]]
			team_id = Team.find_by_name(db_team_name).id 
			player_name = batting_stat["name"].split.map {|nm| nm.downcase }.join(" ")
			player = Player.find_by_name_and_team_id(player_name, team_id)
			next unless player
			player_id = player.id

			cleaned_batting_hash["player_id"] = player_id
			cleaned_batting_hash["sbn"] = cleaned_batting_hash["sb"] - cleaned_batting_hash["cs"]
			cleaned_batting_hash["singles"] = cleaned_batting_hash["hits"] - cleaned_batting_hash["hr"] - cleaned_batting_hash["triples"] - cleaned_batting_hash["doubles"]

			cleaned_batting_stats << cleaned_batting_hash
		end

		return cleaned_batting_stats
	end

	def BattingStat.update_stats
		rows = BattingStat.grab_stats
		parsed_data = BattingStat.parse_stats(rows)
		cleaned_data = BattingStat.clean_data(parsed_data)

		cleaned_data.each do |data|
			batting_stat = BattingStat.find_by_player_id(data["player_id"]) || BattingStat.new
			batting_stat.update_attributes!(data)
		end
		puts "Batting Data Updated"
	end

end