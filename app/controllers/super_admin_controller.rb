class SuperAdminController < ApplicationController
  before_action :authenticate_user!
  before_action :require_super_admin!
  layout 'super_admin'

  private

  def require_super_admin!
    unless current_user&.super_admin?
      redirect_to main_root_path, alert: 'Access denied. Super admin only.'
    end
  end
end
