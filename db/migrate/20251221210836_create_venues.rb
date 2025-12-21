class CreateVenues < ActiveRecord::Migration[8.1]
  def change
    create_table :venues do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name
      t.text :address
      t.string :city
      t.string :province
      t.string :municipality
      t.string :barangay
      t.string :phone
      t.decimal :latitude
      t.decimal :longitude
      t.boolean :active

      t.timestamps
    end
  end
end
