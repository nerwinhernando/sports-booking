require "administrate/base_dashboard"

class ScheduleDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    account: Field::BelongsTo,
    court: Field::BelongsTo,
    day_type: Field::String,
    end_time: Field::Time,
    is_peak_hour: Field::Boolean,
    max_bookings: Field::Number,
    price_cents: Field::Number,
    schedule_date: Field::Date,
    start_time: Field::Time,
    status: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    account
    court
    day_type
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    account
    court
    day_type
    end_time
    is_peak_hour
    max_bookings
    price_cents
    schedule_date
    start_time
    status
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    account
    court
    day_type
    end_time
    is_peak_hour
    max_bookings
    price_cents
    schedule_date
    start_time
    status
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how schedules are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(schedule)
  #   "Schedule ##{schedule.id}"
  # end
end
