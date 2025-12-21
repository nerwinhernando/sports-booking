class CreateSchedules < ActiveRecord::Migration[8.1]
  def change
    create_table :schedules do |t|
      t.references :account, null: false, foreign_key: true
      t.references :court, null: false, foreign_key: true
      t.date :schedule_date
      t.time :start_time
      t.time :end_time
      t.integer :price_cents
      t.string :status
      t.string :day_type
      t.boolean :is_peak_hour
      t.integer :max_bookings

      t.timestamps
    end
  end
end
