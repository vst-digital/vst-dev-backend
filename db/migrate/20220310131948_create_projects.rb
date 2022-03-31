class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.integer :status
      t.integer :organization_id
      t.text :project_description 
      t.timestamps
    end
  end
end
