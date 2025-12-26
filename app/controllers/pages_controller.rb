class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :landing, :search, :about, :contact, :terms, :privacy]

  def home
    # Main marketing site (no subdomain)
    @featured_cities = get_featured_cities
    @total_venues = Venue.active.count
    @total_courts = Court.active.count
    @upcoming_schedules = Schedule.available
                                  .where('schedule_date >= ?', Date.current)
                                  .where('schedule_date <= ?', Date.current + 7.days)
                                  .count
  end

  def landing
    # Tenant landing page (with subdomain)
    if current_account
      @venues = current_account.venues.active.includes(:courts)
      @upcoming_dates = get_upcoming_dates
      @featured_schedules = get_featured_schedules
      @popular_courts = get_popular_courts
    else
      # No account found - should have been caught in set_tenant
      redirect_to main_root_path, alert: 'Venue not found'
    end
  end

  def search
    @query = params[:query]
    @province = params[:province]
    @city = params[:city]
    @date = params[:date]&.to_date || Date.current
    @time = params[:time]
    @court_type = params[:court_type]

    # Search across all venues
    @venues = Venue.active.includes(:courts)

    # Apply location filters
    if @query.present?
      @venues = @venues.where(
        'name ILIKE ? OR city ILIKE ? OR province ILIKE ? OR address ILIKE ?',
        "%#{@query}%", "%#{@query}%", "%#{@query}%", "%#{@query}%"
      )
    end

    @venues = @venues.by_province(@province) if @province.present?
    @venues = @venues.by_city(@city) if @city.present?

    # Filter by court type
    if @court_type.present?
      @venues = @venues.joins(:courts)
                      .where(courts: { court_type: @court_type, active: true })
                      .distinct
    end

    # Get available schedules for the date
    if @date.present?
      venue_ids = @venues.pluck(:id)
      @schedules = Schedule.available
                          .for_date(@date)
                          .joins(court: :venue)
                          .where(venues: { id: venue_ids })
                          .includes(court: :venue)

      # Filter by time if provided
      if @time.present?
        hour = @time.to_i
        @schedules = @schedules.where(
          'EXTRACT(HOUR FROM start_time) = ?', hour
        )
      end

      @schedules_by_venue = @schedules.group_by { |s| s.court.venue }
    end

    @provinces = Venue::PROVINCES
    @cities = Venue.active.distinct.pluck(:city).compact.sort
    @court_types = Court::COURT_TYPES
    @available_times = (6..22).to_a # 6 AM to 10 PM

    @venues = @venues.page(params[:page]).per(12)
  end

  private

  def get_featured_cities
    [
      { name: 'Metro Manila', count: Venue.where(province: 'Metro Manila').active.count, image: '🏙️' },
      { name: 'Cebu', count: Venue.where(province: 'Cebu').active.count, image: '🏝️' },
      { name: 'Davao', count: Venue.where(province: 'Davao del Sur').active.count, image: '🌴' },
      { name: 'Cavite', count: Venue.where(province: 'Cavite').active.count, image: '🏞️' },
      { name: 'Laguna', count: Venue.where(province: 'Laguna').active.count, image: '🏔️' },
      { name: 'Pampanga', count: Venue.where(province: 'Pampanga').active.count, image: '🏛️' }
    ].select { |city| city[:count] > 0 }
  end

  def get_upcoming_dates
    (0..6).map { |i| Date.current + i.days }
  end

  def get_featured_schedules
    return [] unless current_account

    Schedule.available
            .joins(court: :venue)
            .where(venues: { account_id: current_account.id })
            .where('schedule_date >= ?', Date.current)
            .where('schedule_date <= ?', Date.current + 7.days)
            .order(:schedule_date, :start_time)
            .limit(12)
  end

  def get_popular_courts
    return [] unless current_account

    current_account.courts
                   .active
                   .includes(:venue)
                   .limit(6)
  end
end
