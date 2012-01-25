class AddStatusToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :status, :string
  end
end
