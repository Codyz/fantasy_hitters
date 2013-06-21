class CreatePlayers < ActiveRecord::Migration
  def change
  	create_table :players do |t|
  		t.string :fname
  		t.string :lname 
  		t.string :name 
  		t.integer :age 
  		t.integer :pos 
  		t.integer :team_id 
  		t.boolean :batsman

  		t.timestamps
  	end
  end
end
