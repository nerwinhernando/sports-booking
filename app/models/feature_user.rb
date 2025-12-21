class FeatureUser < ApplicationRecord
  belongs_to :account
  belongs_to :feature
end
