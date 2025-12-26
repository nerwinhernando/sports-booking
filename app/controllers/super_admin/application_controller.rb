module SuperAdmin
  class ApplicationController < ApplicationController
    before_action :require_super_admin!
    skip_before_action :set_tenant
    
    def require_super_admin!
      unless current_user&.super_admin?
        redirect_to root_path, alert: 'Access denied. Super admin only.'
      end
    end
  end
end
