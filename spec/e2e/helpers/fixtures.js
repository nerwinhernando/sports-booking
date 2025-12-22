class TestFixtures {
  static getCustomerUser() {
    return {
      firstName: 'Test',
      lastName: 'Customer',
      email: `customer_${Date.now()}@test.com`,
      phone: '+63 917 123 4567',
      password: 'password123'
    };
  }

  static getCoachUser() {
    return {
      firstName: 'Test',
      lastName: 'Coach',
      email: `coach_${Date.now()}@test.com`,
      phone: '+63 917 234 5678',
      password: 'password123'
    };
  }

  static getAdminUser() {
    return {
      email: 'admin@metromanila.badminton.ph',
      password: 'password123'
    };
  }

  static getSuperAdminUser() {
    return {
      email: 'superadmin@badminton.ph',
      password: 'password123'
    };
  }

  static getStaffUser() {
    return {
      email: 'staff@metromanila.ph',
      password: 'password123'
    };
  }

  static getVenueFilters() {
    return {
      province: 'Metro Manila',
      city: 'Quezon City',
      courtType: 'premium',
      floorType: 'wood',
      aircon: true
    };
  }

  static getBookingData() {
    return {
      paymentMethod: 'cash',
      notes: 'Test booking from Playwright'
    };
  }
}

module.exports = { TestFixtures };
