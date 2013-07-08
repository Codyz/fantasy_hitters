class BattingProjection < ActiveRecord::Base
	attr_accessible :company, :gp, :pa, :ab, :bb, :hbp, :k, :hits,
		:singles, :doubles, :triples, :hr, :ba, :obp, :slg, :ops, :sb,
		:cs, :sbn, :r, :rbi, :player_id 


	validates :player_id, :presence => true
	validates :company, :presence => true
	validates :gp, :pa, :ab, :bb, :hbp, :k, :hits, :singles, :doubles, :triples,
		:hr, :ba, :obp, :ops, :sb, :cs, :sbn, :r, :rbi, :numericality => true

	belongs_to :player


	HEADERS = [:name, :gp, :pa, :ab, :bb, :hbp, :k, :hits,
	:singles, :doubles, :triples, :hr, :ba, :obp, :slg, :ops, :sb,
	:cs, :sbn, :r, :rbi]

	

	def BattingProjection.headers 
		HEADERS 
	end

	def row 
		[self.gp, self.pa, self.ab, self.bb, self.hbp, self.k, self.hits, self.singles, self.doubles,
			self.triples, self.hr, self.ba, self.obp, self.slg, self.ops, self.sb, self.cs, self.sbn, self.r, 
			self.rbi].map {|stat| stat.round(3)}
	end

	def rank_row 
		[self.r, self.hr, self.rbi, self.ba, self.obp,
			self.ops, self.ppa, self.sbn].map {|stat| stat.round(3)}
	end

end