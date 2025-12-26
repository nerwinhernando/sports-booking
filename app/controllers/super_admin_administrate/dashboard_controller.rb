module SuperAdminAdministrate
  class DashboardController < SuperAdminAdministrateController
    def index
      @total_accounts = Account.count
      @active_accounts = Account.where(active: true).count
      @total_venues = Venue.count
      @total_users = User.count
      @total_bookings = Booking.count
      @total_revenue = Booking.confirmed.sum(:amount_cents) / 100.0

      @recent_accounts = Account.order(created_at: :desc).limit(5)
      @recent_bookings = Booking.includes(:user, court: :venue).order(created_at: :desc).limit(10)
    end
  end
end
