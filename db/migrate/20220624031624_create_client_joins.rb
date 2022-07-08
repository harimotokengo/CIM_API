class CreateClientJoins < ActiveRecord::Migration[7.0]
  def change
    create_table :client_joins do |t|
      t.references :office, foreign_key: true
      t.references :user, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.integer :belong_side_id, null: false
      t.boolean :admin, default: false
      t.timestamps
    end
  end
end
