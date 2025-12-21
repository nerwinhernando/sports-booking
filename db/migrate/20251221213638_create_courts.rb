class CreateCourts < ActiveRecord::Migration[8.1]
  def change
    create_table :courts do |t|
      t.references :venue, null: false, foreign_key: true
      t.string :court_number, null: false
      t.string :court_type, default: 'standard'
      t.boolean :active

      t.timestamps
    end

    add_index :courts, %i[venue_id court_number], unique: true
  end
end
