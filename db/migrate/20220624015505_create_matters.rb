class CreateMatters < ActiveRecord::Migration[7.0]
  def change
    create_table :matters do |t|
      t.references :user, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.integer :service_price
      t.text :description
      t.date :start_date
      t.date :finish_date
      t.integer :matter_status_id, null: false
      t.boolean :archive, default: true, null: false
      t.timestamps
    end
  end
end
