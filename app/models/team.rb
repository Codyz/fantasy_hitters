class Team < ActiveRecord::Base
	attr_accessible :name, :circuit

	has_many :players
end