class AddBodyToProjectUserMemo < ActiveRecord::Migration[7.0]
  def change
    add_column :project_user_memos, :body, :json, default: []
    add_column :project_user_memos, :answers, :json, default: []
    add_column :project_user_memos, :read, :bool, default: false
  end
end
