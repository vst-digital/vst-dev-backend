class CreateInspectionSheets < ActiveRecord::Migration[7.0]
  def change
    create_table :inspection_sheets do |t|
      t.integer :user_id
      t.json :body, default: []
      t.timestamps
    end
  end
end
