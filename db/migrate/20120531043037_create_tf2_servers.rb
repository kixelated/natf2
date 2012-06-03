class CreateTf2Servers < ActiveRecord::Migration
  def change
    create_table :tf2_servers do |t|
      t.integer :user_id
	  t.string :title
      t.string :ip
      t.string :gametype
      t.integer :players
      t.string :players_list
	  t.string :map
      t.integer :max_players
      t.integer :port, :default => 27015

      t.timestamps
    end
  end
end
