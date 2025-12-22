const { test, expect } = require('@playwright/test');
const { TestHelpers } = require('../helpers/test-helpers');
const { TestFixtures } = require('../helpers/fixtures');

test.describe('Create Booking', () => {
  let helpers;
  let user;

  test.beforeEach(async ({ page }) => {
    helpers = new TestHelpers(page);
    user = TestFixtures.getCustomerUser();
    
    // Register and login
    await helpers.registerUser(user);
  });

  test('should create booking successfully', async ({ page }) => {
    await page.goto('/venues');
    
    // Select venue
    await page.locator('a:has-text("View Details")').first().click();
    await page.waitForLoadState('networkidle');
    
    // Select first available slot
    const firstSlot = page.locator('.border.rounded-lg').first();
    await firstSlot.click();
    await page.waitForLoadState('networkidle');
    
    // Fill booking form
    await helpers.expectToSeeText('Confirm Your Booking');
    await helpers.fillBookingForm('cash', 'Test booking');
    await helpers.submitBooking();
    
    // Verify booking created
    await helpers.waitForSuccess();
    await helpers.expectToSeeText('Booking created');
  });

  test('should display booking summary before confirmation', async ({ page }) => {
    await page.goto('/venues');
    
    await page.locator('a:has-text("View Details")').first().click();
    await page.waitForLoadState('networkidle');
    
    await page.locator('.border.rounded-lg').first().click();
    await page.waitForLoadState('networkidle');
    
    await helpers.expectToSeeText('Booking Details');
    await helpers.expectToSeeText('Total Amount:');
    await expect(page.locator('text=/₱[0-9,]+/')).toBeVisible();
  });

  test('should select payment method', async ({ page }) => {
    await page.goto('/venues');
    
    await page.locator('a:has-text("View Details")').first().click();
    await page.waitForLoadState('networkidle');
    
    await page.locator('.border.rounded-lg').first().click();
    await page.waitForLoadState('networkidle');
    
    await page.selectOption('select[name="booking[payment_method]"]', 'gcash');
    const selectedValue = await page.locator('select[name="booking[payment_method]"]').inputValue();
    expect(selectedValue).toBe('gcash');
  });

  test('should add notes to booking', async ({ page }) => {
    await page.goto('/venues');
    
    await page.locator('a:has-text("View Details")').first().click();
    await page.waitForLoadState('networkidle');
    
    await page.locator('.border.rounded-lg').first().click();
    await page.waitForLoadState('networkidle');
    
    const notes = 'Special request: Need extra shuttlecocks';
    await page.fill('textarea[name="booking[notes]"]', notes);
    
    const value = await page.locator('textarea[name="booking[notes]"]').inputValue();
    expect(value).toBe(notes);
  });

  test('should cancel booking creation', async ({ page }) => {
    await page.goto('/venues');
    
    await page.locator('a:has-text("View Details")').first().click();
    await page.waitForLoadState('networkidle');
    
    const venueName = await page.locator('h1').textContent();
    
    await page.locator('.border.rounded-lg').first().click();
    await page.waitForLoadState('networkidle');
    
    await page.click('a:has-text("Cancel")');
    await page.waitForLoadState('networkidle');
    
    await helpers.expectToSeeText(venueName);
  });

  test('should require login to book', async ({ page, context }) => {
    // Clear session
    await context.clearCookies();
    
    await page.goto('/venues');
    await page.locator('a:has-text("View Details")').first().click();
    await page.waitForLoadState('networkidle');
    
    await page.locator('.border.rounded-lg').first().click();
    await page.waitForLoadState('networkidle');
    
    // Should redirect to sign in
    await helpers.expectToBeOnPage('/users/sign_in');
  });

  test('should show cancellation policy', async ({ page }) => {
    await page.goto('/venues');
    
    await page.locator('a:has-text("View Details")').first().click();
    await page.waitForLoadState('networkidle');
    
    await page.locator('.border.rounded-lg').first().click();
    await page.waitForLoadState('networkidle');
    
    await helpers.expectToSeeText('Cancellation Policy');
  });
});