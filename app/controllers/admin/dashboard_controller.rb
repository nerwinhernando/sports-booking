module Admin
  class DashboardController < AdminController
    def index
      @total_bookings = current_account.bookings.count
      @total_revenue = current_account.bookings.confirmed.sum(:amount_cents) / 100.0
      @total_customers = current_account.users.where(role: 'customer').count
      @pending_bookings = current_account.bookings.where(status: 'pending').count
      @today_bookings = current_account.bookings.where(
        'DATE(start_time) = ?', Date.current
      ).count

      # Booking statistics by status
      @booking_stats = {
        confirmed: current_account.bookings.where(status: 'confirmed').count,
        pending: current_account.bookings.where(status: 'pending').count,
        completed: current_account.bookings.where(status: 'completed').count,
        cancelled: current_account.bookings.where(status: 'cancelled').count
      }

      # Payment method statistics
      @payment_stats = {
        cash: current_account.bookings.where(payment_method: 'cash').count,
        gcash: current_account.bookings.where(payment_method: 'gcash').count,
        paymaya: current_account.bookings.where(payment_method: 'paymaya').count,
        card: current_account.bookings.where(payment_method: 'card').count
      }

      @payment_amounts = {
        cash: current_account.bookings.where(payment_method: 'cash').sum(:amount_cents) / 100.0,
        gcash: current_account.bookings.where(payment_method: 'gcash').sum(:amount_cents) / 100.0,
        paymaya: current_account.bookings.where(payment_method: 'paymaya').sum(:amount_cents) / 100.0,
        card: current_account.bookings.where(payment_method: 'card').sum(:amount_cents) / 100.0
      }

      # Recent bookings
      @recent_bookings = current_account.bookings
                                       .includes(:user, :court)
                                       .order(created_at: :desc)
                                       .limit(5)
    end
  end
end
