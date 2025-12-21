class Booking < ApplicationRecord
  belongs_to :account
  belongs_to :user
  belongs_to :court
  belongs_to :schedule
end
