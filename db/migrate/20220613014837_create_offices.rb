class CreateOffices < ActiveRecord::Migration[7.0]
  def change
    create_table :offices do |t|
      t.string :name, null: false
      t.string :phone_number, null: false
      t.string :post_code
      t.string :prefecture
      t.string :address
      t.boolean :archive, default: true, null: false
      t.timestamps
    end
  end
end
