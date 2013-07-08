class CreateLeagues < ActiveRecord::Migration
  def change
  	create_table :leagues do |t|
  		t.integer :user_id

  		t.integer :num_c
  		t.integer :num_1b
  		t.integer :num_2b
  		t.integer :num_3b
  		t.integer :num_ss
  		t.integer :num_lf
  		t.integer :num_cf
  		t.integer :num_rf
  		t.integer :num_dh

  		t.integer :num_teams

  		t.timestamps
  	end
  end
end
