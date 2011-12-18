class AddSteamidToUsers < ActiveRecord::Migration
  def up
    add_column :users, :steamid, :string
  end
  
  
  def down
    remove_column :users, :steamid
  end
end
