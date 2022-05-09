class CreateProjectUserMemos < ActiveRecord::Migration[7.0]
  def change
    create_table :project_user_memos do |t|
      t.integer :receiver_id
      t.integer :sender_id
      t.string :bcc, array: true, default: []
      t.string :cc, array: true, default: []
      t.integer :project_id
      t.text :subject
      t.text :content
      t.timestamps
    end
  end
end