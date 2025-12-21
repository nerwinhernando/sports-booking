class PagesController < ApplicationController
  def home
    if request.subdomain.present? && request.subdomain != 'www'
      @account = Account.find_by(subdomain: request.subdomain)
      if @account
        set_current_tenant(@account)
        # @venues = Venue.includes(:courts).all
        @venues = Venue.all
      else
        redirect_to root_url(subdomain: 'www'), alert: "Account not found"
      end
    else
      ActsAsTenant.without_tenant do
        @accounts = Account.all
      end
    end
  end
end
