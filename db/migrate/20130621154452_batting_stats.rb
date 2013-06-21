class BattingStats < ActiveRecord::Migration
  def change
  	create_table :batting_stats do |t|
  		t.integer :player_id

  		t.integer :gp
  		t.integer :pa
  		t.float :ab
  		t.float :bb
  		t.float :hbp
  		t.float :k
  		t.float :hits
  		t.float :singles
			t.float :doubles
			t.float :triples
			t.float :hr
			t.float :ba
			t.float :obp
			t.float :slg
			t.float :ops
			t.float :sb
			t.float :cs 
			t.float :sbn
			t.float :r 
			t.float :rbi
			t.float :ppa 

			t.timestamps 
		end
	end
end
