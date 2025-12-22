const { test, expect } = require('@playwright/test');
const { TestHelpers } = require('../helpers/test-helpers');
const { TestFixtures } = require('../helpers/fixtures');

test.describe('Admin Dashboard', () => {
  let helpers;

  test.beforeEach(async ({ page }) => {
    helpers = new TestHelpers(page);
    const admin = TestFixtures.getAdminUser();
    
    await page.goto('http://metromanila.lvh.me:3000');
    await helpers.login(admin.email, admin.password);
  });

  test('should access admin dashboard', async ({ page }) => {
    await page.goto('http://metromanila.lvh.me:3000/admin');
    
    await helpers.expectToSeeText('Users');
    await expect(page).toHaveURL(/.*\/admin/);
  });

  test('should view users list', async ({ page }) => {
    await page.goto('http://metromanila.lvh.me:3000/admin/users');
    
    await helpers.expectToSeeText('Users');
    await expect(page.locator('table, .collection')).toBeVisible();
  });

  test('should view venues list', async ({ page }) => {
    await page.goto('http://metromanila.lvh.me:3000/admin/venues');
    
    await helpers.expectToSeeText('Venues');
    await expect(page.locator('table, .collection')).toBeVisible();
  });

  test('should view bookings list', async ({ page }) => {
    await page.goto('http://metromanila.lvh.me:3000/admin/bookings');
    
    await helpers.expectToSeeText('Bookings');
    await expect(page.locator('table, .collection')).toBeVisible();
  });

  test('should view schedules', async ({ page }) => {
    await page.goto('http://metromanila.lvh.me:3000/admin/schedules');
    
    await helpers.expectToSeeText('Schedules');
  });

  test('should not allow customer access to admin', async ({ page, context }) => {
    await helpers.logout();
    
    const customer = TestFixtures.getCustomerUser();
    await helpers.registerUser(customer);
    
    await page.goto('http://metromanila.lvh.me:3000/admin');
    
    // Should redirect or show access denied
    await helpers.expectToSeeText('Access denied');
  });
});
