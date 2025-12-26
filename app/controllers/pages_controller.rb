class PagesController < ApplicationController
  # def home
  #   if request.subdomain.present? && request.subdomain != 'www'
  #     @account = Account.find_by(subdomain: request.subdomain)
  #     if @account
  #       set_current_tenant(@account)
  #       @venues = Venue.includes(:courts).all
  #       # @venues = Venue.all
  #     else
  #       redirect_to root_url(subdomain: 'www'), alert: "Account not found"
  #     end
  #   else
  #     ActsAsTenant.without_tenant do
  #       @accounts = Account.all
  #     end
  #   end
  # end

  def home
    @featured_cities = get_featured_cities
    @total_venues = Venue.active.count
    @total_courts = Court.active.count
    @upcoming_schedules = Schedule.available
                                  .where('schedule_date >= ?', Date.current)
                                  .where('schedule_date <= ?', Date.current + 7.days)
                                  .count
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
end
