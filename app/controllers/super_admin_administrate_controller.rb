class SuperAdminAdministrateController < Administrate::ApplicationController
  # before_action :authenticate_admin

  # def authenticate_admin
  #   unless current_user&.super_admin?
  #     redirect_to main_root_path, alert: 'Access denied. Super admin only.'
  #   end
  # end

  before_action :authenticate_user!
  before_action :require_super_admin!
  layout 'super_admin_administrate/application'

  private

  def require_super_admin!
    unless current_user&.super_admin?
      redirect_to main_root_path, alert: 'Access denied. Super admin only.'
    end
  end
end
