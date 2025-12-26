class AdminController < ApplicationController
  before_action :require_venue_staff!

  private

  def require_venue_staff!
    unless current_user&.venue_staff?
      redirect_to root_path, alert: 'Access denied. Staff only.'
    end
  end
end

