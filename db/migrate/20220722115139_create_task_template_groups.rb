class CreateTaskTemplateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :task_template_groups do |t|
      t.references :user, foreign_key: true
      t.references :office, foreign_key: true
      t.references :matter_category, null: false, foreign_key: true
      t.string :name, nul: false
      t.text :description
      t.boolean :public_flg, default: false, null: false
      t.timestamps
    end
  end
end
