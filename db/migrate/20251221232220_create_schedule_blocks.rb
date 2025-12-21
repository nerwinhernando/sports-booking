class CreateScheduleBlocks < ActiveRecord::Migration[8.1]
  def change
    create_table :schedule_blocks do |t|
      t.references :account, null: false, foreign_key: true
      t.references :court, null: false, foreign_key: true
      t.date :block_date
      t.time :start_time
      t.time :end_time
      t.string :reason
      t.text :notes
      t.boolean :all_day

      t.timestamps
    end
  end
end
