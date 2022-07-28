class CreateTaskTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :task_templates do |t|
      t.references :work_stage, null: false, foreign_key: true
      t.references :task_template_group, null: false, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end
  end
end
