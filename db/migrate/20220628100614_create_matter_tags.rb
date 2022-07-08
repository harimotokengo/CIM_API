class CreateMatterTags < ActiveRecord::Migration[7.0]
  def change
    create_table :matter_tags do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :matter, null: false, foreign_key: true
      t.timestamps
    end
  end
end
