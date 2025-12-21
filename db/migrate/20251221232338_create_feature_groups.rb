class CreateFeatureGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :feature_groups do |t|
      t.references :account, null: false, foreign_key: true
      t.references :feature, null: false, foreign_key: true
      t.string :group_name
      t.boolean :enabled

      t.timestamps
    end
  end
end
