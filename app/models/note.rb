class Note < ActiveRecord::Base
	attr_accessible :player_id, :user_id, :body

	validates :user_id, :player_id, :presence => true

	belongs_to :player 
	belongs_to :user
end