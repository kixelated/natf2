class AddUploadCategory < ActiveRecord::Migration
  def change
    create_table :upload_categories do |t|
      t.string :name
    end

    add_column :uploads, :category_id, :integer
  end
end
