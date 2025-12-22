puts "Seeding multi-tenant badminton booking system..."


# Create Super Admin (no tenant)
puts "\n👑 Creating Super Admin..."
super_admin = ActsAsTenant.without_tenant do
  User.create!(
    email: 'super@example.com',
    password: 'password123',
    password_confirmation: 'password123',
    first_name: 'Super',
    last_name: 'Admin',
    role: :super_admin,
    phone: '555-0000'
  )
end
puts "   ✓ Created: #{super_admin.email}"

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
    # Create Company Admin
    puts "  👤 Creating Company Admin..."
    admin = User.create!(
      email: "admin@#{account.subdomain}.com",
      password: 'password123',
      password_confirmation: 'password123',
      first_name: 'Admin',
      last_name: account.name.split.first,
      role: :admin,
      account: account,
      phone: "555-#{rand(1000..9999)}"
    )
    puts "     ✓ #{admin.full_name} (#{admin.email})"

    # Create staff user
    staff = User.find_or_create_by!(email: "staff@#{account.subdomain}.ph") do |u|
      u.password = 'password123'
      u.password_confirmation = 'password123'
      u.first_name = 'Staff'
      u.last_name = 'Member'
      u.phone = '+63 917 111 1111'
      u.role = 'staff'
      u.account = account
    end
    puts "    ✓ Staff: #{staff.email}"

    # Create venue
    venue = Venue.find_or_create_by!(name: account.name) do |v|
      v.address = account_data[:address]
      v.city = account_data[:city]
      v.province = account_data[:province]
      v.phone = account_data[:phone]
      v.account = account
    end

    # Create courts with different types
    court_configs = [
      { number: 'Court 1', type: 'standard', floor: 'wood', aircon: false },
      { number: 'Court 2', type: 'standard', floor: 'wood', aircon: false },
      { number: 'Court 3', type: 'premium', floor: 'wood', aircon: true },
      { number: 'Court 4', type: 'vip', floor: 'synthetic', aircon: true }
    ]

    court_configs.each do |config|
      Court.find_or_create_by!(venue: venue, court_number: config[:number], account: account) do |c|
        c.price_per_hour = config[:type] == 'standard' ? 500 : (config[:type] == 'premium' ? 750 : 1000)
        c.court_type = config[:type]
        c.floor_type = config[:floor]
        c.has_air_conditioning = config[:aircon]
        c.lighting_type = 'led'
        c.ceiling_height = 9.5
      end
    end
    puts "    ✓ Created #{court_configs.size} courts"
  end
end

# Create customers (no account)
puts "\nCreating customers..."

customers_data = [
  {
    email: 'player1@gmail.com',
    first_name: 'Pedro',
    last_name: 'Garcia',
    phone: '+63 917 555 0001',
    role: 'customer',
    player_type: 'singles',
    skill_level: 'intermediate'
  },
  {
    email: 'coach1@gmail.com',
    first_name: 'Anna',
    last_name: 'Reyes',
    phone: '+63 917 555 0002',
    role: 'coach',
    player_type: 'both',
    skill_level: 'professional'
  }
]

customers_data.each do |customer_data|
  customer = User.find_or_create_by!(email: customer_data[:email]) do |u|
    u.password = 'password123'
    u.password_confirmation = 'password123'
    u.first_name = customer_data[:first_name]
    u.last_name = customer_data[:last_name]
    u.phone = customer_data[:phone]
    u.role = customer_data[:role]
    u.player_type = customer_data[:player_type]
    u.skill_level = customer_data[:skill_level]
    # u.account = nil
  end
  puts "  ✓ #{customer.role.titleize}: #{customer.email}"
end

puts "\n✅ Seed completed!"
puts "\nLogin Credentials:"
puts "  Super Admin: superadmin@badminton.ph / password123"
puts "\nAccounts:"
accounts_data.each do |data|
  puts "  - #{data[:subdomain]}.localhost:3000"
  puts "    Admin: #{data[:owner_email]} / password123"
  puts "    Staff: staff@#{data[:subdomain]}.ph / password123"
end
puts "\nCustomers (can book at any venue):"
customers_data.each do |data|
  puts "  - #{data[:email]} / password123"
end
