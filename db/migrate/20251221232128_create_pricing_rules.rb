class CreatePricingRules < ActiveRecord::Migration[8.1]
  def change
    create_table :pricing_rules do |t|
      t.references :account, null: false, foreign_key: true
      t.references :venue, null: false, foreign_key: true
      t.string :day_type
      t.time :start_time
      t.time :end_time
      t.integer :price_per_hour_cents
      t.boolean :active

      t.timestamps
    end
  end
end
