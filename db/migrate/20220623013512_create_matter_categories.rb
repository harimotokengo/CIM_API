class CreateMatterCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :matter_categories do |t|
      t.string :name, null: false
      t.string :ancestry
      t.timestamps
    end
  end
end
