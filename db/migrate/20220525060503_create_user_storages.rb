class CreateUserStorages < ActiveRecord::Migration[7.0]
  def change
    create_table :user_storages do |t|
      t.integer :user_id
      t.integer :project_id
      t.string :name
      t.timestamps
    end
  end
end
