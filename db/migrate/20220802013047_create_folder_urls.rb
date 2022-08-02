class CreateFolderUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :folder_urls do |t|
      t.string :name, null: false
      t.text :url, null: false
      t.references :matter, foreign_key: true
      t.timestamps
    end
  end
end
