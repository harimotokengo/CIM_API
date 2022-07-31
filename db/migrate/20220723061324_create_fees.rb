class CreateFees < ActiveRecord::Migration[7.0]
  def change
    create_table :fees do |t|
      t.integer :fee_type_id, null: false
      t.integer :price, null: false
      t.text :description
      t.date :deadline
      t.integer :pay_times, null: false
      t.integer :monthly_date_id
      t.integer :current_payment
      t.integer :price_type, null: false
      t.date :paid_date
      t.integer :paid_amount
      t.boolean :pay_off, default: false, null: false
      t.boolean :archive, default: true, null: false
      t.references :matter, foreign_key: true, null: false
      t.references :task, foreign_key: true, null: false
      t.timestamps
    end
  end
end
