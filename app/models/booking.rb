class Booking < ApplicationRecord
  # belongs_to :account
  belongs_to :user
  belongs_to :court
  belongs_to :schedule
  has_one :account, through: :court
  has_one :venue, through: :court

  STATUSES = %w[pending confirmed cancelled completed].freeze
  validates :status, inclusion: { in: STATUSES }

  scope :upcoming, -> { where('start_time > ?', Time.current).order(:start_time) }
  scope :past, -> { where('end_time < ?', Time.current).order(start_time: :desc) }
  scope :confirmed, -> { where(status: 'confirmed') }
  scope :pending, -> { where(status: 'pending') }
  scope :for_user, ->(user) { where(user: user) }
end
