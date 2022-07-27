class CreateWorkStages < ActiveRecord::Migration[7.0]
  def change
    create_table :work_stages do |t|
      t.references :user, foreign_key: true
      t.references :office, foreign_key: true
      t.references :matter_category, null: false, foreign_key: true
      t.string :name, nul: false
      t.boolean :archive, default: true, null: false
      t.timestamps
    end
  end
end
