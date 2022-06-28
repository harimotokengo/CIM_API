class CreateOpponents < ActiveRecord::Migration[7.0]
  def change
    create_table :opponents do |t|
      t.string :name, null: false
      t.string :name_kana, null: false
      t.string :first_name
      t.string :first_name_kana
      t.string :maiden_name
      t.string :maiden_name_kana
      t.text :profile
      t.date :birth_date
      t.integer :opponent_relation_type, null: false
      t.references :matter, null: false, foreign_key: true
      t.timestamps
    end
  end
end
