class AddStylesheetToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stylesheet, :string, :default => "application"
  end
end
