class CreateTfservers < ActiveRecord::Migration
  def change
    create_table :tfservers do |t|
      t.integer :user_id
      t.string :title
	  t.string :servertitle
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
