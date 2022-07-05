class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :first_name
      t.string :name_kana, null: false
      t.string :first_name_kana
      t.string :maiden_name
      t.string :maiden_name_kana
      t.text :profile
      t.string :indentification_number
      t.date :birth_date
      t.integer :client_type_id, null: false
      t.boolean :archive, default: true, null: false
      t.timestamps
    end
  end
end
