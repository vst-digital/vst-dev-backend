class CreateUserMemoTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :user_memo_templates do |t|
      t.integer :user_id
      t.integer :project_id
      t.text :memo_text
      t.timestamps
    end
  end
end
