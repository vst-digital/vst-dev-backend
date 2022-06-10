class CreateUserInspectionSheets < ActiveRecord::Migration[7.0]
  def change
    create_table :user_inspection_sheets do |t|

      t.timestamps
    end
  end
end
