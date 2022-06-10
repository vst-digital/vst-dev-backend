class CreateUserStorageAccesses < ActiveRecord::Migration[7.0]
  def change
    create_table :user_storage_accesses do |t|
      t.integer :user_storage_id
      t.integer :shared_with_id
      t.integer :shared_by_id
      t.integer :project_id
      t.timestamps
    end
  end
end
