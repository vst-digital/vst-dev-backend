class CreateStorageData < ActiveRecord::Migration[7.0]
  def change
    create_table :storage_data do |t|
      t.integer :user_storage_id
      t.integer :project_id
      t.text :name
      t.boolean :isDirectory, default: false
      t.integer :size 
      t.bigint :parent_id
      t.bigint :__KEY__
      t.timestamps
    end
  end
end
