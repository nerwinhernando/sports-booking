# Sports Booking App

Multi-tenant sports facility booking platform built with Ruby on Rails 8.1.

## Requirements

- Ruby 3.2.3+
- Rails 8.1
- PostgreSQL
- Bundler

## Installation

```bash
# Clone or extract the project
cd sports_booking_app

# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate
rails db:seed

# Start server
rails server
```

## Quick Start

Access the application at:
- Main site: http://lvh.me:3000
- Elite Badminton: http://elite.lvh.me:3000
- Pro Sports: http://prosports.lvh.me:3000

## Features

### Multi-Tenancy
- Subdomain-based tenant isolation
- Complete data separation per company
- Each company has independent users, venues, courts, and bookings

### User Roles
- **Super Admin**: Manages all companies across the platform
- **Admin**: Full control over company data
- **Staff**: Manages bookings and customer service
- **Client**: Creates bookings and leaves reviews

### Booking System
- Real-time availability checking
- Automatic price calculation based on duration
- Time slot overlap prevention
- Multiple payment methods (Cash, GCash, PayMaya, Credit Card)
- Booking statuses (Pending, Confirmed, Cancelled, Completed)
- Payment status tracking (Unpaid, Paid, Refunded)

### Admin Dashboard
Access at: http://elite.lvh.me:3000/admin

Manage:
- Companies (super admin only)
- Users
- Venues
- Courts
- Bookings
- Reviews

### RESTful API
Full JSON API with JWT authentication for mobile apps.

Base URLs:
- Elite: http://elite.lvh.me:3000/api/v1
- Pro Sports: http://prosports.lvh.me:3000/api/v1

## Database Schema

```
companies
├── name
└── subdomain (unique)

users
├── email
├── encrypted_password
├── role (client, staff, admin, super_admin)
└── company_id

venues
├── name
├── address
└── company_id

courts
├── name
├── court_type (badminton, tennis, basketball, volleyball)
├── price_per_hour
└── venue_id

bookings
├── court_id
├── user_id
├── start_time
├── end_time
├── status (pending, confirmed, cancelled, completed)
├── total_price
├── payment_method (cash, gcash, paymaya, credit_card)
└── payment_status (unpaid, paid, refunded)

reviews
├── booking_id
├── user_id
├── rating (1-5)
└── comment
```

## Sample Data

After running `rails db:seed`, you'll have:

### Companies
1. **Elite Badminton Center**
   - Subdomain: elite
   - URL: http://elite.lvh.me:3000

2. **Pro Sports Complex**
   - Subdomain: prosports
   - URL: http://prosports.lvh.me:3000

### Credentials

**Super Admin** (access all companies)
```
Email: superadmin@sportsbooking.com
Password: password123
```

**Elite Badminton Center**
```
Admin: admin@elite.com / password123
Staff: staff@elite.com / password123
Clients: 
  - john@gmail.com / password123
  - maria@gmail.com / password123
```

**Pro Sports Complex**
```
Admin: admin@prosports.com / password123
Staff: staff@prosports.com / password123
Clients:
  - juan@gmail.com / password123
  - ana@yahoo.com / password123
```

## API Documentation

### Authentication

All endpoints except register/login require JWT token in Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

### Endpoints

#### Authentication
```bash
# Register
POST /api/v1/auth/register
{
  "user": {
    "email": "newuser@gmail.com",
    "password": "password123",
    "password_confirmation": "password123"
  }
}

# Login
POST /api/v1/auth/login
{
  "email": "john@gmail.com",
  "password": "password123"
}

# Get current user
GET /api/v1/auth/me
```

#### Venues
```bash
# List all venues
GET /api/v1/venues

# Get venue details
GET /api/v1/venues/:id
```

#### Courts
```bash
# List all courts
GET /api/v1/courts

# Get court details
GET /api/v1/courts/:id

# Filter courts by venue
GET /api/v1/courts?venue_id=1

# Filter by court type
GET /api/v1/courts?court_type=badminton
```

#### Bookings
```bash
# List my bookings
GET /api/v1/bookings

# Get booking details
GET /api/v1/bookings/:id

# Create booking
POST /api/v1/bookings
{
  "booking": {
    "court_id": 1,
    "start_time": "2025-01-15T10:00:00",
    "end_time": "2025-01-15T12:00:00",
    "payment_method": "gcash"
  }
}

# Update booking
PATCH /api/v1/bookings/:id
{
  "booking": {
    "payment_status": "paid",
    "status": "confirmed"
  }
}

# Cancel booking
DELETE /api/v1/bookings/:id
```

#### Reviews
```bash
# List all reviews
GET /api/v1/reviews

# Get review details
GET /api/v1/reviews/:id

# Create review (booking must be completed)
POST /api/v1/bookings/:booking_id/reviews
{
  "review": {
    "rating": 5,
    "comment": "Excellent facilities!"
  }
}

# Update review
PATCH /api/v1/reviews/:id
{
  "review": {
    "rating": 4,
    "comment": "Good overall experience"
  }
}

# Delete review
DELETE /api/v1/reviews/:id
```

### API Response Format

**Success Response:**
```json
{
  "message": "Success message",
  "data": { ... }
}
```

**Error Response:**
```json
{
  "error": "Error message"
}
```
or
```json
{
  "errors": ["Error 1", "Error 2"]
}
```

## Testing with Postman

1. Import `Sports_Booking_API.postman_collection.json`
2. Import `Sports_Booking_Elite.postman_environment.json` or `Sports_Booking_ProSports.postman_environment.json`
3. Select environment in top-right dropdown
4. Run "Login" request to get JWT token
5. Token automatically saves to environment variable
6. Test other endpoints

## Testing with RSpec

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/booking_spec.rb

# Run with documentation format
bundle exec rspec --format documentation
```

## Development

### Create new migration
```bash
rails generate migration MigrationName
```

### View routes
```bash
rails routes
```

### Rails console
```bash
rails console
```

### Reset database
```bash
rails db:drop db:create db:migrate db:seed
```

## Project Structure

```
sports_booking_app/
├── app/
│   ├── controllers/
│   │   ├── admin/              # Administrate admin controllers
│   │   ├── api/v1/             # API controllers with JWT auth
│   │   ├── users/              # Custom Devise controllers
│   │   ├── application_controller.rb
│   │   └── pages_controller.rb
│   ├── models/                 # All ActiveRecord models
│   ├── serializers/            # API JSON serializers
│   ├── dashboards/             # Administrate dashboards
│   └── views/
│       ├── layouts/
│       ├── pages/
│       └── devise/             # Authentication views
├── config/
│   ├── initializers/
│   │   ├── acts_as_tenant.rb   # Multi-tenancy config
│   │   ├── devise.rb           # Authentication config
│   │   └── letter_opener.rb    # Email preview config
│   ├── routes.rb
│   └── database.yml
├── db/
│   ├── migrate/
│   └── seeds.rb
├── spec/                       # RSpec tests
└── Gemfile
```

## Tech Stack

### Core
- Ruby 3.2.3
- Rails 8.1.0
- PostgreSQL

### Authentication & Authorization
- Devise - Web authentication
- JWT - API authentication
- bcrypt - Password encryption

### Multi-Tenancy
- acts_as_tenant - Row-level multi-tenancy

### Admin
- Administrate - Admin dashboard

### API
- active_model_serializers - JSON serialization
- jbuilder - JSON templates

### Testing
- RSpec Rails
- Factory Bot Rails
- Faker
- Capybara
- Shoulda Matchers

### Development
- Letter Opener - Email preview
- Web Console
- Debug

## Configuration

### Multi-Tenancy
Configured in `config/initializers/acts_as_tenant.rb`
- Row-level tenancy
- Tenant scoping on models with `acts_as_tenant(:company)`
- Automatic tenant setting via subdomain

### Devise
Configured in `config/initializers/devise.rb`
- Email authentication
- Password recovery
- Remember me functionality
- Session timeout

### Letter Opener
Development emails open in browser
Access at: http://localhost:3000/letter_opener

## Deployment Considerations

### Environment Variables
Set these in production:
```
DATABASE_URL=postgresql://user:pass@localhost/dbname
RAILS_ENV=production
SECRET_KEY_BASE=generate_with_rails_secret
```

### Database
```bash
RAILS_ENV=production rails db:create
RAILS_ENV=production rails db:migrate
RAILS_ENV=production rails db:seed
```

### Assets
```bash
RAILS_ENV=production rails assets:precompile
```

### Subdomain Configuration
Configure wildcard DNS for production domain:
```
*.yourdomain.com -> your_server_ip
```

## Security Notes

- All passwords encrypted with bcrypt
- JWT tokens expire after 24 hours
- CSRF protection enabled for web requests
- SQL injection protection via ActiveRecord
- XSS protection via Rails HTML escaping
- Sensitive parameters filtered in logs

## License

Private project - All rights reserved

## Support

For issues or questions:
1. Check the logs: `tail -f log/development.log`
2. Run migrations: `rails db:migrate`
3. Reset database: `rails db:drop db:create db:migrate db:seed`
4. Check routes: `rails routes | grep booking`

## Contributing

This is a private project. Contributions are not currently accepted.

---

Built with ❤️ using Ruby on Rails
