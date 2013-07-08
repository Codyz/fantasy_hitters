class Player < ActiveRecord::Base
	attr_accessible :fname, :lname, :age, :pos, :team_id, :batsman, :name

	validates :batsman, :inclusion => {:in => [true, false]}
	validates :pos, :presence => true
	validates :fname, :lname, :name, :presence => true
	validates :pos, :inclusion => {:in => (1..11).to_a}

	has_many :batting_projections
	#has_many :pitching_projections
	has_one :batting_stat
	#has_one :pitching_stat

	belongs_to :team
	delegate :circuit, :to => :team


	POSITION_NUMBERS = {
	"sp" => 1,
	"c" => 2,
	"1b" => 3,
	"2b" => 4,
	"3b" => 5,
	"ss" => 6,
	"lf" => 7,
	"cf" => 8,
	"rf" => 9,
	"dh" => 10,
	"rp" => 11
	}

	POSITION_TITLES = {
		1 => "Pitcher",
		2 => "Catchers",
		3 => "First Basemen",
		4 => "Second Basemen",
		5 => "Third Basemen",
		6 => "Shortstops",
		7 => "Left Fielders",
		8 => "Center Fielders",
		9 => "Right Fielders",
		10 => "Designated Hitters"
	}


	def Player.position_names 
		POSITION_NUMBERS.invert
	end

	def Player.position_name(n)
		Player.position_names[n]
	end

	def Player.position_title(n)
		POSITION_TITLES[n]
	end

	def Player.all_position_members(n)
		players = Player.where(:pos => n)
		players
	end

	def Player.search(search)
		if search
			find(:all, :conditions => ['fname LIKE ? OR lname LIKE ?', "%#{search}%", "%#{search}%"])
		else
			find(:all)
		end
	end

	def my_position_name
		Player.position_names[self.pos]
	end

	def team_name 
		self.team.name 
	end

	def circuit_name 
		self.circuit 
	end


end