class CreateBelongingInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :belonging_infos do |t|
      t.references :user, foreign_key: true
      t.references :office, foreign_key: true
      t.integer :status_id
      t.integer :default_price
      t.boolean :admin
      t.timestamps
    end
  end
end
