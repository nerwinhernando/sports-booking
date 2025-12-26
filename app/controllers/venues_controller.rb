class VenuesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :search, :schedules]

  def index
    @venues = Venue.active.includes(:courts)

    # Apply filters
    @venues = @venues.by_province(params[:province]) if params[:province].present?
    @venues = @venues.by_city(params[:city]) if params[:city].present?

    if params[:court_type].present?
      @venues = @venues.joins(:courts)
                      .where(courts: { court_type: params[:court_type], active: true })
                      .distinct
    end

    # Apply search query if present
    if params[:query].present?
      @venues = @venues.where(
        'name ILIKE ? OR city ILIKE ? OR province ILIKE ? OR address ILIKE ?',
        "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%"
      )
    end

    # Store total count before pagination
    @total_venues = @venues.count

    # Paginate
    @venues = @venues.page(params[:page]).per(20)

    # Get filter options
    @provinces = Venue::PROVINCES
    @cities = Venue.active.distinct.pluck(:city).compact.sort
    @court_types = Court::COURT_TYPES
    @floor_types = Court::FLOOR_TYPES
  end

  def show
    @venue = Venue.find(params[:id])
    @courts = @venue.courts.active
    @date = params[:date]&.to_date || Date.current

    # Get available schedules for the date
    @schedules = @venue.schedules
                      .available
                      .for_date(@date)
                      .includes(:court)
                      .order(:start_time)

    @schedules_by_court = @schedules.group_by(&:court)

    # Get upcoming dates for quick selection
    @upcoming_dates = (0..6).map { |i| Date.current + i.days }
  end

  def schedules
    @venue = Venue.find(params[:id])
    @start_date = params[:start_date]&.to_date || Date.current
    @end_date = params[:end_date]&.to_date || @start_date + 7.days

    @schedules = @venue.schedules
                      .available
                      .where(schedule_date: @start_date..@end_date)
                      .includes(:court)
                      .order(:schedule_date, :start_time)

    @schedules_by_date = @schedules.group_by(&:schedule_date)

    respond_to do |format|
      format.html
      format.json { render json: @schedules }
    end
  end

  def search
    # Redirect to pages#search for unified search experience
    redirect_to search_path(params.permit!)
  end
end
