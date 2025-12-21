class PricingRule < ApplicationRecord
  belongs_to :account
  belongs_to :venue
end
