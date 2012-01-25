class AddDescriptionToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :description, :string
  end
end
