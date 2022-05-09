class CreateProjectUserMemoReplies < ActiveRecord::Migration[7.0]
  def change
    create_table :project_user_memo_replies do |t|
      t.integer :project_user_memo_id
      t.text :content
      t.integer :created_by
      t.timestamps
    end
  end
end
