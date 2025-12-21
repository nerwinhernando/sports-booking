class FeatureVenue < ApplicationRecord
  belongs_to :account
  belongs_to :feature
  belongs_to :venue
end
