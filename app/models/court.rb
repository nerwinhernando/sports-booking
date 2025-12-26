class Court < ApplicationRecord
  acts_as_tenant :account
  belongs_to :account
  belongs_to :venue

  has_many :schedules, dependent: :destroy

  COURT_TYPES = %w[standard premium vip training].freeze
  validates :court_type, inclusion: { in: COURT_TYPES }

  FLOOR_TYPES = %w[wood synthetic rubber concrete].freeze
  validates :floor_type, inclusion: { in: FLOOR_TYPES }, allow_nil: true

  LIGHTING_TYPES = %w[natural led fluorescent halogen].freeze
  validates :lighting_type, inclusion: { in: LIGHTING_TYPES }, allow_nil: true

  scope :active, -> { where(active: true) }
  scope :by_type, ->(type) { where(court_type: type) if type.present? }
  scope :by_floor_type, ->(floor) { where(floor_type: floor) if floor.present? }
  scope :with_aircon, -> { where(has_air_conditioning: true) }
end
