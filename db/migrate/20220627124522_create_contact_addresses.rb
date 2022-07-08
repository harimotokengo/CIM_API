class CreateContactAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_addresses do |t|
      t.integer :category, null: false
      t.string :memo
      t.string :post_code
      t.string :prefecture
      t.string :address
      t.string :building_name
      t.boolean :send_by_personal, default: false
      t.references :client, foreign_key: true
      t.references :opponent, foreign_key: true
      t.timestamps
    end
  end
end
