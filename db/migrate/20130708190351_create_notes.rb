class CreateNotes < ActiveRecord::Migration
  def change
 		create_table :notes do |t|
 			t.integer :user_id
 			t.integer :player_id
 			t.text :body

 			t.timestamps
 		end
 	end
end
