class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_tenant
  before_action :authenticate_user!, unless: :skip_authentication?
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_account

  private

  def skip_authentication?
    devise_controller? || public_action?
  end

  def public_action?
    # Public controllers and actions that don't require authentication
    public_controllers = {
      'pages' => ['home', 'landing', 'search', 'about', 'contact', 'terms', 'privacy'],
      'venues' => ['index', 'show', 'search'],
      'courts' => ['index', 'show', 'availability', 'schedules', 'search'],
      'schedules' => ['index', 'show', 'available', 'calendar'],
      'errors' => ['not_found', 'unprocessable_entity', 'internal_server_error']
  }

    public_controllers[controller_name]&.include?(action_name)
  end

  def set_tenant
    # Skip tenant for public pages on main site
    return skip_tenant if skip_tenant_context?

    # Handle devise separately
    return handle_devise_tenant if devise_controller?

    # Handle tenant routing
    handle_tenant_routing
  end

  def skip_tenant_context?
    # Skip for main site public pages
    return true if controller_name == 'pages' && ['home', 'search', 'about', 'contact', 'terms', 'privacy'].include?(action_name)
    return true if controller_path.start_with?('api/', 'webhooks/', 'rails/')
    return true if controller_name == 'errors'

    # Skip for public browsing without subdomain
    if request.subdomain.blank? || request.subdomain == 'www'
      return true if ['venues', 'courts', 'schedules'].include?(controller_name)
    end

    false
  end

  def skip_tenant
    ActsAsTenant.current_tenant = nil
    @current_account = nil
  end

  def handle_devise_tenant
    if request.subdomain.present? && request.subdomain != 'www'
      account = Account.find_by(subdomain: request.subdomain, active: true)
      ActsAsTenant.current_tenant = account
      @current_account = account
    else
      skip_tenant
    end
  end

  def handle_tenant_routing
    if request.subdomain.present? && request.subdomain != 'www'
      account = Account.find_by(subdomain: request.subdomain, active: true)

      if account
        ActsAsTenant.current_tenant = account
        @current_account = account
      else
        # Render 404 for invalid subdomain
        render file: "#{Rails.root}/public/404.html",
               layout: false,
               status: :not_found
      end
    else
      skip_tenant
    end
  end

  def current_account
    @current_account
  end

  def require_super_admin!
    unless current_user&.super_admin?
      redirect_to main_root_path, alert: 'Access denied. Super admin only.'
    end
  end

  def require_venue_staff!
    unless current_user&.venue_staff?
      redirect_to (current_account ? tenant_root_path : main_root_path), alert: 'Access denied. Staff only.'
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone, :player_type, :skill_level])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone, :player_type, :skill_level])
  end

  def after_sign_in_path_for(resource)
    if resource.super_admin?
      super_admin_root_path
    elsif resource.venue_staff? && current_account
      admin_root_path
    else
      stored_location_for(resource) || (current_account ? tenant_root_path : main_root_path)
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    current_account ? tenant_root_path : main_root_path
  end
end
