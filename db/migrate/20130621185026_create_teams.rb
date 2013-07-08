class CreateTeams < ActiveRecord::Migration
  def change
  	create_table :teams do |t|
  		t.string :name 
  		t.string :circuit
  	end
  end
end
