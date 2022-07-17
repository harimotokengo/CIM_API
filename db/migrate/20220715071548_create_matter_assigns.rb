class CreateMatterAssigns < ActiveRecord::Migration[7.0]
  def change
    create_table :matter_assigns do |t|
      t.references :matter, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
