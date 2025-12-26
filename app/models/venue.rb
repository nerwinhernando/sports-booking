class Venue < ApplicationRecord
  acts_as_tenant :account
  belongs_to :account
  has_many :courts, dependent: :destroy
  has_many :schedules, through: :courts

  validates :name, presence: true
  validates :city, presence: true

  PROVINCES = [
    'Metro Manila',
    'Cavite',
    'Laguna',
    'Batangas',
    'Rizal',
    'Bulacan',
    'Pampanga',
    'Cebu',
    'Davao del Sur'
  ].freeze

  scope :active, -> { where(active: true) }
  scope :by_province, ->(province) { where(province: province) if province.present? }
  scope :by_city, ->(city) { where(city: city) if city.present? }
  scope :in_metro_manila, -> { where(province: 'Metro Manila') }
  scope :search_location, ->(query) {
    where('province ILIKE ? OR city ILIKE ? OR municipality ILIKE ?',
          "%#{query}%", "%#{query}%", "%#{query}%") if query.present?
  }

  def full_address
    parts = [address, barangay, municipality || city, province].compact
    parts.join(', ')
  end
end
