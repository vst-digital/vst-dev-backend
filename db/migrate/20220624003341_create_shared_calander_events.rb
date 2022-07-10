class CreateSharedCalanderEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :shared_calander_events do |t|
      t.integer :user_id, null: false
      t.integer :shared_with_id
      t.integer :calander_id, null: false

      t.timestamps
    end
  end
end
