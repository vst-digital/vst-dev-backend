class CreateProjectGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :project_groups do |t|
      t.integer :project_id
      t.integer :group_id
      t.timestamps
    end
  end
end
