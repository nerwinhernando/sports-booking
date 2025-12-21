class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  set_current_tenant_through_filter
  before_action :set_tenant

  private

  def set_tenant
    subdomain = request.subdomain.presence || 'www'

    if subdomain == 'www' || subdomain.blank?
      # Main domain - no tenant context
      ActsAsTenant.without_tenant do
        # Allow access to main pages
      end
    else
      account = Account.find_by(subdomain: subdomain)

      if account
        set_current_tenant(account)
      else
        redirect_to root_url(subdomain: 'www'), alert: "Account not found", allow_other_host: true
      end
    end
  end

  def current_account
    ActsAsTenant.current_tenant
  end
  helper_method :current_account
end
