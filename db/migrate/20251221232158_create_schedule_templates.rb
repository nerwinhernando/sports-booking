class CreateScheduleTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :schedule_templates do |t|
      t.references :account, null: false, foreign_key: true
      t.references :venue, null: false, foreign_key: true
      t.string :name
      t.string :day_of_week
      t.time :start_time
      t.time :end_time
      t.integer :slot_duration_minutes
      t.integer :price_cents
      t.string :day_type
      t.boolean :is_peak_hour
      t.boolean :active

      t.timestamps
    end
  end
end
