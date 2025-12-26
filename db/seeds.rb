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
  # Metro Manila Venues
  {
    name: 'Ynares Sports Arena - Badminton Center',
    subdomain: 'ynares',
    owner_name: 'Jose Ynares',
    owner_email: 'admin@ynares.badminton.ph',
    phone: '+63 917 123 4567',
    address: 'Ortigas Avenue',
    city: 'Pasig',
    province: 'Metro Manila',
    municipality: nil,
    barangay: 'San Antonio',
    plan: 'enterprise',
    courts: 8,
    latitude: 14.5858,
    longitude: 121.0614,
    active: true
  },
  {
    name: 'Rizal Memorial Badminton Hall',
    subdomain: 'rizalmemorial',
    owner_name: 'Maria Clara Santos',
    owner_email: 'admin@rizalmemorial.badminton.ph',
    phone: '+63 917 234 5678',
    address: 'Pablo Ocampo Sr. Avenue',
    city: 'Manila',
    province: 'Metro Manila',
    municipality: nil,
    barangay: 'Malate',
    plan: 'premium',
    courts: 6,
    latitude: 14.5764,
    longitude: 120.9933,
    active: true
  },
  {
    name: 'SM Mall of Asia Badminton Courts',
    subdomain: 'moabadminton',
    owner_name: 'Henry Sy Jr.',
    owner_email: 'admin@moabadminton.ph',
    phone: '+63 917 345 6789',
    address: 'SM Mall of Asia Complex',
    city: 'Pasay',
    province: 'Metro Manila',
    municipality: nil,
    barangay: 'Bay City',
    plan: 'enterprise',
    courts: 10,
    latitude: 14.5362,
    longitude: 120.9822,
    active: true
  },
  {
    name: 'Ultra Badminton Center',
    subdomain: 'ultra',
    owner_name: 'Ricardo Santos',
    owner_email: 'admin@ultra.badminton.ph',
    phone: '+63 917 456 7890',
    address: 'Epifanio de los Santos Avenue',
    city: 'Pasig',
    province: 'Metro Manila',
    municipality: nil,
    barangay: 'Ugong',
    plan: 'premium',
    courts: 12,
    latitude: 14.5875,
    longitude: 121.0542,
    active: true
  },
  {
    name: 'Araneta Coliseum Sports Complex',
    subdomain: 'araneta',
    owner_name: 'Jorge Araneta',
    owner_email: 'admin@araneta.badminton.ph',
    phone: '+63 917 567 8901',
    address: 'General Romulo Avenue',
    city: 'Quezon City',
    province: 'Metro Manila',
    municipality: nil,
    barangay: 'Cubao',
    plan: 'enterprise',
    courts: 8,
    latitude: 14.6201,
    longitude: 121.0514,
    active: true
  },
  {
    name: 'BGC Badminton Hub',
    subdomain: 'bgc',
    owner_name: 'Antonio Garcia',
    owner_email: 'admin@bgc.badminton.ph',
    phone: '+63 917 678 9012',
    address: '5th Avenue corner 26th Street',
    city: 'Taguig',
    province: 'Metro Manila',
    municipality: nil,
    barangay: 'Fort Bonifacio',
    plan: 'premium',
    courts: 6,
    latitude: 14.5513,
    longitude: 121.0470,
    active: true
  },
  {
    name: 'Makati Sports Club - Badminton',
    subdomain: 'makatisports',
    owner_name: 'Isabel Roxas',
    owner_email: 'admin@makatisports.ph',
    phone: '+63 917 789 0123',
    address: 'Ayala Avenue',
    city: 'Makati',
    province: 'Metro Manila',
    municipality: nil,
    barangay: 'Bel-Air',
    plan: 'enterprise',
    courts: 10,
    latitude: 14.5547,
    longitude: 121.0244,
    active: true
  },
  {
    name: 'Marikina Sports Center',
    subdomain: 'marikina',
    owner_name: 'Fernando Reyes',
    owner_email: 'admin@marikina.badminton.ph',
    phone: '+63 917 890 1234',
    address: 'Shoe Avenue',
    city: 'Marikina',
    province: 'Metro Manila',
    municipality: nil,
    barangay: 'Sta. Elena',
    plan: 'basic',
    courts: 4,
    latitude: 14.6507,
    longitude: 121.1029,
    active: true
  },
  # Cavite
  {
    name: 'Imus Sports Complex',
    subdomain: 'imus',
    owner_name: 'Emmanuel Cruz',
    owner_email: 'admin@imus.badminton.ph',
    phone: '+63 917 901 2345',
    address: 'Aguinaldo Highway',
    city: 'Imus',
    province: 'Cavite',
    municipality: 'Imus',
    barangay: 'Poblacion',
    plan: 'premium',
    courts: 6,
    latitude: 14.4297,
    longitude: 120.9367,
    active: true
  },
  {
    name: 'Tagaytay Highlands Badminton Club',
    subdomain: 'tagaytay',
    owner_name: 'Victoria Mendoza',
    owner_email: 'admin@tagaytay.badminton.ph',
    phone: '+63 917 012 3456',
    address: 'Tagaytay-Calamba Road',
    city: 'Tagaytay',
    province: 'Cavite',
    municipality: 'Tagaytay',
    barangay: 'Maharlika East',
    plan: 'premium',
    courts: 5,
    latitude: 14.1053,
    longitude: 120.9601,
    active: true
  },
  {
    name: 'Dasmariñas Badminton Arena',
    subdomain: 'dasmarinas',
    owner_name: 'Roberto Villanueva',
    owner_email: 'admin@dasmarinas.badminton.ph',
    phone: '+63 917 123 4568',
    address: 'Governors Drive',
    city: 'Dasmariñas',
    province: 'Cavite',
    municipality: 'Dasmariñas',
    barangay: 'Paliparan',
    plan: 'basic',
    courts: 4,
    latitude: 14.3294,
    longitude: 120.9367,
    active: true
  },
  # Laguna
  {
    name: 'Sta. Rosa Sports Hub',
    subdomain: 'starosa',
    owner_name: 'Miguel Torres',
    owner_email: 'admin@starosa.badminton.ph',
    phone: '+63 917 234 5679',
    address: 'Greenfield City',
    city: 'Sta. Rosa',
    province: 'Laguna',
    municipality: 'Sta. Rosa',
    barangay: 'Don Jose',
    plan: 'premium',
    courts: 8,
    latitude: 14.3123,
    longitude: 121.1114,
    active: true
  },
  {
    name: 'Calamba Premier Badminton',
    subdomain: 'calamba',
    owner_name: 'Elena Aquino',
    owner_email: 'admin@calamba.badminton.ph',
    phone: '+63 917 345 6780',
    address: 'National Highway',
    city: 'Calamba',
    province: 'Laguna',
    municipality: 'Calamba',
    barangay: 'Real',
    plan: 'basic',
    courts: 5,
    latitude: 14.2167,
    longitude: 121.1655,
    active: true
  },
  {
    name: 'Los Baños Sports Complex',
    subdomain: 'losbanos',
    owner_name: 'Carlos Bautista',
    owner_email: 'admin@losbanos.badminton.ph',
    phone: '+63 917 456 7891',
    address: 'Lopez Avenue',
    city: 'Los Baños',
    province: 'Laguna',
    municipality: 'Los Baños',
    barangay: 'Poblacion',
    plan: 'basic',
    courts: 4,
    latitude: 14.1656,
    longitude: 121.2414,
    active: true
  },
  # Bulacan
  {
    name: 'Malolos Sports Arena',
    subdomain: 'malolos',
    owner_name: 'Rosa Hernandez',
    owner_email: 'admin@malolos.badminton.ph',
    phone: '+63 917 567 8902',
    address: 'MacArthur Highway',
    city: 'Malolos',
    province: 'Bulacan',
    municipality: 'Malolos',
    barangay: 'Poblacion',
    plan: 'premium',
    courts: 6,
    latitude: 14.8433,
    longitude: 120.8114,
    active: true
  },
  {
    name: 'San Jose del Monte Badminton Center',
    subdomain: 'sjdm',
    owner_name: 'Pedro Dela Cruz',
    owner_email: 'admin@sjdm.badminton.ph',
    phone: '+63 917 678 9013',
    address: 'Quirino Highway',
    city: 'San Jose del Monte',
    province: 'Bulacan',
    municipality: 'San Jose del Monte',
    barangay: 'Tungkong Mangga',
    plan: 'basic',
    courts: 5,
    latitude: 14.8139,
    longitude: 121.0453,
    active: true
  },
  # Pampanga
  {
    name: 'Angeles City Sports Complex',
    subdomain: 'angeles',
    owner_name: 'Luis Gonzales',
    owner_email: 'admin@angeles.badminton.ph',
    phone: '+63 917 789 0124',
    address: 'MacArthur Highway',
    city: 'Angeles City',
    province: 'Pampanga',
    municipality: 'Angeles City',
    barangay: 'Balibago',
    plan: 'premium',
    courts: 8,
    latitude: 15.1450,
    longitude: 120.5887,
    active: true
  },
  {
    name: 'San Fernando Pampanga Badminton Hub',
    subdomain: 'sanfernando',
    owner_name: 'Teresa Santos',
    owner_email: 'admin@sanfernando.badminton.ph',
    phone: '+63 917 890 1235',
    address: 'Jose Abad Santos Avenue',
    city: 'San Fernando',
    province: 'Pampanga',
    municipality: 'San Fernando',
    barangay: 'Del Rosario',
    plan: 'basic',
    courts: 4,
    latitude: 15.0294,
    longitude: 120.6897,
    active: true
  },
  # Rizal
  {
    name: 'Antipolo Sports Arena',
    subdomain: 'antipolo',
    owner_name: 'Juan Rizal',
    owner_email: 'admin@antipolo.badminton.ph',
    phone: '+63 917 901 2346',
    address: 'Sumulong Highway',
    city: 'Antipolo',
    province: 'Rizal',
    municipality: 'Antipolo',
    barangay: 'Dela Paz',
    plan: 'premium',
    courts: 7,
    latitude: 14.5865,
    longitude: 121.1755,
    active: true
  },
  {
    name: 'Cainta Badminton Center',
    subdomain: 'cainta',
    owner_name: 'Angela Ramos',
    owner_email: 'admin@cainta.badminton.ph',
    phone: '+63 917 012 3457',
    address: 'Ortigas Avenue Extension',
    city: 'Cainta',
    province: 'Rizal',
    municipality: 'Cainta',
    barangay: 'San Andres',
    plan: 'basic',
    courts: 4,
    latitude: 14.5781,
    longitude: 121.1222,
    active: true
  },
  # Cebu
  {
    name: 'Cebu City Sports Center - Badminton',
    subdomain: 'cebu',
    owner_name: 'Ramon Cebu',
    owner_email: 'admin@cebu.badminton.ph',
    phone: '+63 917 123 4569',
    address: 'Osmeña Boulevard',
    city: 'Cebu City',
    province: 'Cebu',
    municipality: 'Cebu City',
    barangay: 'Tinago',
    plan: 'enterprise',
    courts: 10,
    latitude: 10.3157,
    longitude: 123.8854,
    active: true
  },
  {
    name: 'Mandaue Sports Complex',
    subdomain: 'mandaue',
    owner_name: 'Sofia Ramirez',
    owner_email: 'admin@mandaue.badminton.ph',
    phone: '+63 917 234 5680',
    address: 'A.S. Fortuna Street',
    city: 'Mandaue City',
    province: 'Cebu',
    municipality: 'Mandaue City',
    barangay: 'Bakilid',
    plan: 'premium',
    courts: 6,
    latitude: 10.3233,
    longitude: 123.9222,
    active: true
  },
  {
    name: 'Lapu-Lapu City Badminton Arena',
    subdomain: 'lapulapu',
    owner_name: 'Eduardo Fernandez',
    owner_email: 'admin@lapulapu.badminton.ph',
    phone: '+63 917 345 6781',
    address: 'M.L. Quezon National Highway',
    city: 'Lapu-Lapu City',
    province: 'Cebu',
    municipality: 'Lapu-Lapu City',
    barangay: 'Poblacion',
    plan: 'basic',
    courts: 5,
    latitude: 10.3103,
    longitude: 123.9494,
    active: true
  },

  # Davao
  {
    name: 'Davao City Badminton Complex',
    subdomain: 'davao',
    owner_name: 'Maria Davao',
    owner_email: 'admin@davao.badminton.ph',
    phone: '+63 917 456 7892',
    address: 'J.P. Laurel Avenue',
    city: 'Davao City',
    province: 'Davao del Sur',
    municipality: 'Davao City',
    barangay: 'Poblacion',
    plan: 'enterprise',
    courts: 12,
    latitude: 7.0731,
    longitude: 125.6128,
    active: true
  },
  {
    name: 'Tagum Sports Hub',
    subdomain: 'tagum',
    owner_email: 'admin@tagum.badminton.ph',
    owner_name: 'Gabriel Lopez',
    phone: '+63 917 567 8903',
    address: 'Apokon Road',
    city: 'Tagum City',
    province: 'Davao del Norte',
    municipality: 'Tagum City',
    barangay: 'Apokon',
    plan: 'basic',
    courts: 4,
    latitude: 7.4474,
    longitude: 125.8078,
    active: true
  },
  # Batangas
  {
    name: 'Lipa City Badminton Arena',
    subdomain: 'lipa',
    owner_name: 'Benjamin Castro',
    owner_email: 'admin@lipa.badminton.ph',
    phone: '+63 917 678 9014',
    address: 'P. Torres Street',
    city: 'Lipa City',
    province: 'Batangas',
    municipality: 'Lipa City',
    barangay: 'Poblacion',
    plan: 'premium',
    courts: 6,
    latitude: 13.9411,
    longitude: 121.1633,
    active: true
  },
  {
    name: 'Batangas City Sports Complex',
    subdomain: 'batangas',
    owner_name: 'Carmen Silva',
    owner_email: 'admin@batangas.badminton.ph',
    phone: '+63 917 789 0125',
    address: 'Rizal Avenue',
    city: 'Batangas City',
    province: 'Batangas',
    municipality: 'Batangas City',
    barangay: 'Poblacion',
    plan: 'premium',
    courts: 5,
    latitude: 13.7565,
    longitude: 121.0583,
    active: true
  }
]

accounts_data.each do |account_data|
  account = Account.find_or_create_by!(subdomain: account_data[:subdomain]) do |a|
    a.name = account_data[:name]
    a.owner_name = account_data[:owner_name]
    a.owner_email = account_data[:owner_email]
    a.phone = account_data[:phone]
    a.address = account_data[:address]
    a.city = account_data[:city]
    a.province = account_data[:province]
    a.plan = account_data[:plan]
    a.active = account_data[:active]
  end

  puts "  ✓ Account created: #{account.subdomain}"
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
      v.municipality = account_data[:municipality]
      v.barangay = account_data[:barangay]
      v.phone = account_data[:phone]
      v.latitude = account_data[:latitude]
      v.longitude = account_data[:longitude]
      v.active = true
      v.account = account
    end

    puts "    ✓ Venue: #{venue.name}"

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
        c.active = true
      end
    end
    puts "    ✓ Created #{court_configs.size} courts"
  end
end

puts "\n👥 Creating customer accounts..."

customers_data = [
  {
    email: 'player1@gmail.com',
    first_name: 'Juan',
    last_name: 'Dela Cruz',
    phone: '+63 917 555 0001',
    role: 'customer',
    player_type: 'singles',
    skill_level: 'intermediate'
  },
  {
    email: 'player2@gmail.com',
    first_name: 'Maria',
    last_name: 'Santos',
    phone: '+63 917 555 0002',
    role: 'customer',
    player_type: 'doubles',
    skill_level: 'advanced'
  },
  {
    email: 'player3@gmail.com',
    first_name: 'Pedro',
    last_name: 'Garcia',
    phone: '+63 917 555 0003',
    role: 'customer',
    player_type: 'both',
    skill_level: 'beginner'
  },
  {
    email: 'coach1@gmail.com',
    first_name: 'Anna',
    last_name: 'Reyes',
    phone: '+63 917 555 0004',
    role: 'coach',
    player_type: 'both',
    skill_level: 'professional'
  },
  {
    email: 'coach2@gmail.com',
    first_name: 'Roberto',
    last_name: 'Gonzales',
    phone: '+63 917 555 0005',
    role: 'coach',
    player_type: 'both',
    skill_level: 'professional'
  },
  {
    email: 'vip1@gmail.com',
    first_name: 'Isabella',
    last_name: 'Mendoza',
    phone: '+63 917 555 0006',
    role: 'customer',
    player_type: 'singles',
    skill_level: 'advanced',
    loyalty_points: 1500
  },
  {
    email: 'vip2@gmail.com',
    first_name: 'Miguel',
    last_name: 'Fernandez',
    phone: '+63 917 555 0007',
    role: 'customer',
    player_type: 'doubles',
    skill_level: 'professional',
    loyalty_points: 2000
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
    u.loyalty_points = customer_data[:loyalty_points] || 0
    u.account = nil
  end
  puts "  ✓ #{customer.role.titleize}: #{customer.email}"
end

# ============================================
# CREATE SAMPLE BOOKINGS
# ============================================

puts "\n📅 Creating sample bookings..."

# Get a few venues to create bookings for
sample_accounts = Account.limit(5)
sample_customer = User.where(role: 'customer').first

sample_accounts.each do |account|
  ActsAsTenant.with_tenant(account) do
    venue = account.venues.first
    next unless venue

    # Create 3 bookings for tomorrow
    schedules = venue.schedules.for_date(Date.tomorrow).available.limit(3)

    schedules.each do |schedule|
      booking = Booking.create!(
        user: sample_customer,
        schedule: schedule,
        court: schedule.court,
        start_time: schedule.datetime_start,
        end_time: schedule.datetime_end,
        amount_cents: schedule.price_cents,
        status: ['pending', 'confirmed'].sample,
        payment_method: ['cash', 'gcash', 'paymaya'].sample,
        notes: 'Sample booking'
      )
      puts "  ✓ Booking created at #{venue.name}"
    end
  end
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
