class CreateFeatureVenues < ActiveRecord::Migration[8.1]
  def change
    create_table :feature_venues do |t|
      t.references :account, null: false, foreign_key: true
      t.references :feature, null: false, foreign_key: true
      t.references :venue, null: false, foreign_key: true
      t.boolean :enabled

      t.timestamps
    end
  end
end
