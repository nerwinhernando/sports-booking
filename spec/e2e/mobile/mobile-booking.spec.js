const { test, expect } = require('@playwright/test');
const { TestHelpers } = require('../helpers/test-helpers');
const { TestFixtures } = require('../helpers/fixtures');

test.describe('Mobile Booking', () => {
  test.use({ 
    viewport: { width: 375, height: 667 },
    isMobile: true 
  });

  let helpers;
  let user;

  test.beforeEach(async ({ page }) => {
    helpers = new TestHelpers(page);
    user = TestFixtures.getCustomerUser();
    
    await helpers.registerUser(user);
  });

  test('should browse venues on mobile', async ({ page }) => {
    await page.goto('/venues');
    
    await helpers.expectToSeeText('Find Courts');
    await expect(page.locator('.grid')).toBeVisible();
  });

  test('should filter venues on mobile', async ({ page }) => {
    await page.goto('/venues');
    
    await page.selectOption('select[name="province"]', 'Metro Manila');
    await page.click('input[type="submit"]:has-text("Apply Filters")');
    
    await page.waitForLoadState('networkidle');
    await helpers.expectToSeeText('Metro Manila');
  });

  test('should create booking on mobile', async ({ page }) => {
    await page.goto('/venues');
    
    await page.locator('a:has-text("View Details")').first().click();
    await page.waitForLoadState('networkidle');
    
    await page.locator('.border.rounded-lg').first().click();
    await page.waitForLoadState('networkidle');
    
    await helpers.fillBookingForm('cash');
    await helpers.submitBooking();
    
    await helpers.waitForSuccess();
  });

  test('should navigate menu on mobile', async ({ page }) => {
    await page.goto('/');
    
    // Check if mobile menu is accessible
    const menuButton = page.locator('button[aria-label="Menu"], button.hamburger');
    if (await menuButton.isVisible()) {
      await menuButton.click();
    }
    
    await helpers.expectToSeeText('My Bookings');
  });
});
