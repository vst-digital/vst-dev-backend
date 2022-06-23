class CreateCalanders < ActiveRecord::Migration[7.0]
  def change
    create_table :calanders do |t|
      t.integer :user_id
      t.integer :project_id
      t.timestamp :start_date
      t.timestamp :end_date
      t.string :subject
      t.string :location

      t.timestamps
    end
  end
end
