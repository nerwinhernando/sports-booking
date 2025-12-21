class CreateCourts < ActiveRecord::Migration[8.1]
  def change
    create_table :courts do |t|
      t.references :account, null: false, foreign_key: true
      t.references :venue, null: false, foreign_key: true
      t.string :court_number, null: false
      t.string :court_type, default: 'standard'
      t.decimal :price_per_hour, precision: 10, scale: 2, null: false
      t.string :floor_type
      t.string :lighting_type
      t.boolean :has_air_conditioning, default: false
      t.decimal :ceiling_height
      t.boolean :active

      t.timestamps
    end

    add_index :courts, %i[venue_id court_number], unique: true
  end
end
