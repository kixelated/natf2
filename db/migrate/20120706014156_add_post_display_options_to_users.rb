class AddPostDisplayOptionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :show_avatar, :boolean, :default => true
    add_column :users, :show_user_detail, :boolean, :default => true
  end
end
