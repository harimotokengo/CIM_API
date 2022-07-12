class CreateMatterCategoryJoins < ActiveRecord::Migration[7.0]
  def change
    create_table :matter_category_joins do |t|
      t.references :matter, null: false, foreign_key: true
      t.references :matter_category, null: false, foreign_key: true
      t.timestamps
    end
  end
end
