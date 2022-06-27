class CreateContactPhoneNumbers < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_phone_numbers do |t|
      t.integer :category, null: false
      t.string :memo
      t.string :phone_number
      t.references :client, foreign_key: true
      t.references :opponent, foreign_key: true
      t.timestamps
    end
  end
end
