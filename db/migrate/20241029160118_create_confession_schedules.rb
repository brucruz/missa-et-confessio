class CreateConfessionSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :confession_schedules do |t|
      t.references :church, null: false, foreign_key: true
      t.integer :day_of_week
      t.time :start_time
      t.time :end_time
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :confession_schedules, [ :church_id, :day_of_week ]
  end
end
