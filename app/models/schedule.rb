class Schedule < ApplicationRecord
  belongs_to :account
  belongs_to :court
  has_one :booking, dependent: :nullify
  has_one :venue, through: :court

  scope :available, -> { where(status: 'available') }
  scope :booked, -> { where(status: 'booked') }
  scope :for_date, ->(date) { where(schedule_date: date) }
  scope :upcoming, -> { where('schedule_date >= ?', Date.current).order(:schedule_date, :start_time) }
  scope :past, -> { where('schedule_date < ?', Date.current).order(schedule_date: :desc, start_time: :desc) }
  scope :peak_hours, -> { where(is_peak_hour: true) }
  scope :off_peak, -> { where(is_peak_hour: false) }
end
