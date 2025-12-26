module ApplicationHelper
  def main_site_url(path = '/')
    protocol = Rails.env.production? ? 'https://' : 'http://'
    host = request.host.split('.').last(2).join('.')
    port = Rails.env.development? ? ":#{request.port}" : ''
    "#{protocol}#{host}#{port}#{path}"
  end

  def tenant_url(subdomain, path = '/')
    protocol = Rails.env.production? ? 'https://' : 'http://'
    host = request.host.split('.').last(2).join('.')
    port = Rails.env.development? ? ":#{request.port}" : ''
    "#{protocol}#{subdomain}.#{host}#{port}#{path}"
  end

  def current_site_name
    current_account ? current_account.name : 'BadmintonPH'
  end

  def format_currency(amount_cents)
    "₱#{number_with_delimiter((amount_cents / 100.0), delimiter: ',', precision: 2)}"
  end

  def format_date(date)
    date.strftime('%B %d, %Y')
  end

  def format_time(time)
    time.strftime('%I:%M %p')
  end

  def format_datetime(datetime)
    datetime.strftime('%B %d, %Y at %I:%M %p')
  end

  def booking_status_badge(status)
    case status
    when 'pending'
      content_tag(:span, status.titleize, class: 'px-3 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800')
    when 'confirmed'
      content_tag(:span, status.titleize, class: 'px-3 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800')
    when 'cancelled'
      content_tag(:span, status.titleize, class: 'px-3 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800')
    when 'completed'
      content_tag(:span, status.titleize, class: 'px-3 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800')
    else
      content_tag(:span, status.titleize, class: 'px-3 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800')
    end
  end

  def schedule_status_badge(status)
    case status
    when 'available'
      content_tag(:span, status.titleize, class: 'px-3 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800')
    when 'booked'
      content_tag(:span, status.titleize, class: 'px-3 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800')
    when 'blocked'
      content_tag(:span, status.titleize, class: 'px-3 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800')
    when 'maintenance'
      content_tag(:span, status.titleize, class: 'px-3 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800')
    else
      content_tag(:span, status.titleize, class: 'px-3 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800')
    end
  end

  def user_role_badge(role)
    case role
    when 'super_admin'
      content_tag(:span, 'Super Admin', class: 'px-3 py-1 text-xs font-semibold rounded-full bg-purple-100 text-purple-800')
    when 'admin'
      content_tag(:span, 'Admin', class: 'px-3 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800')
    when 'venue_manager'
      content_tag(:span, 'Manager', class: 'px-3 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800')
    when 'staff'
      content_tag(:span, 'Staff', class: 'px-3 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800')
    when 'coach'
      content_tag(:span, 'Coach', class: 'px-3 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800')
    when 'customer'
      content_tag(:span, 'Customer', class: 'px-3 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800')
    else
      content_tag(:span, role.titleize, class: 'px-3 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800')
    end
  end

  def breadcrumbs
    crumbs = []
    
    # Add home
    if current_account
      crumbs << link_to('Home', tenant_root_path, class: 'text-blue-600 hover:text-blue-800')
    else
      crumbs << link_to('Home', main_root_path, class: 'text-blue-600 hover:text-blue-800')
    end
    
    # Add controller-specific crumbs
    case controller_name
    when 'venues'
      crumbs << link_to('Venues', venues_path, class: 'text-blue-600 hover:text-blue-800')
      crumbs << content_tag(:span, @venue.name, class: 'text-gray-600') if @venue
    when 'bookings'
      crumbs << link_to('My Bookings', bookings_path, class: 'text-blue-600 hover:text-blue-800')
      crumbs << content_tag(:span, "Booking ##{@booking.id}", class: 'text-gray-600') if @booking
    end
    
    safe_join(crumbs, content_tag(:span, ' / ', class: 'mx-2 text-gray-400'))
  end
end
