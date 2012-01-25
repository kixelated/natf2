class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.integer :user_id
      t.string :provider
      t.string :identifier
      t.string :title
      t.integer :viewers
      t.boolean :live, :default => false

      t.timestamps
    end
  end
end
