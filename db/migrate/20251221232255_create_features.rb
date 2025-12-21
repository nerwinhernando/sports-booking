class CreateFeatures < ActiveRecord::Migration[8.1]
  def change
    create_table :features do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.boolean :enabled
      t.integer :rollout_percentage

      t.timestamps
    end
  end
end
