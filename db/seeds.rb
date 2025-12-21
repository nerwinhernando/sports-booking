puts "Seeding multi-tenant badminton booking system..."

# Create sample accounts
puts "\nCreating accounts..."

accounts_data = [
  {
    name: 'Metro Manila Badminton',
    subdomain: 'metromanila',
    owner_name: 'Juan Dela Cruz',
    owner_email: 'admin@metromanila.badminton.ph',
    phone: '+63 917 123 4567',
    city: 'Quezon City',
    plan: 'premium'
  },
  {
    name: 'Makati Sports Hub',
    subdomain: 'makati',
    owner_name: 'Maria Santos',
    owner_email: 'admin@makati.badminton.ph',
    phone: '+63 917 234 5678',
    city: 'Makati',
    plan: 'basic'
  }
]

accounts_data.each do |account_data|
  account = Account.find_or_create_by!(subdomain: account_data[:subdomain]) do |a|
    a.name = account_data[:name]
    a.owner_name = account_data[:owner_name]
    a.owner_email = account_data[:owner_email]
    a.phone = account_data[:phone]
    a.city = account_data[:city]
    a.plan = account_data[:plan]
  end
  puts "  ✓ #{account.name} (#{account.subdomain})"

  # Create admin user for each account
  ActsAsTenant.with_tenant(account) do
    admin = User.find_or_create_by!(email: account_data[:owner_email]) do |u|
      u.password = 'password123'
      u.password_confirmation = 'password123'
      u.first_name = account_data[:owner_name].split.first
      u.last_name = account_data[:owner_name].split.last
      u.phone = account_data[:phone]
      u.role = 'admin'
      u.account = account
    end
    puts "    ✓ Admin user: #{admin.email}"

    # Create sample customer
    customer = User.find_or_create_by!(email: "customer@#{account.subdomain}.ph") do |u|
      u.password = 'password123'
      u.password_confirmation = 'password123'
      u.first_name = 'Regular'
      u.last_name = 'Customer'
      u.phone = '+63 917 999 9999'
      u.role = 'customer'
      u.account = account
    end
    puts "    ✓ Customer user: #{customer.email}"
  end
end

puts "\n✅ Seed completed!"
puts "\nAccounts created:"
accounts_data.each do |data|
  puts "  - #{data[:subdomain]}.localhost:3000"
  puts "    Admin: #{data[:owner_email]} / password123"
  puts "    Customer: customer@#{data[:subdomain]}.ph / password123"
end
