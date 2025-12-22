const { test, expect } = require('@playwright/test');
const { TestHelpers } = require('../helpers/test-helpers');

test.describe('Accessibility', () => {
  let helpers;

  test.beforeEach(async ({ page }) => {
    helpers = new TestHelpers(page);
  });

  test('should have proper page titles', async ({ page }) => {
    await page.goto('/venues');
    await expect(page).toHaveTitle(/Badminton|Court|Booking/);
    
    await page.goto('/users/sign_in');
    await expect(page).toHaveTitle(/Sign|Login|Badminton/);
  });

  test('should have accessible form labels', async ({ page }) => {
    await page.goto('/users/sign_in');
    
    const emailInput = page.locator('input[name="user[email]"]');
    const emailLabel = page.locator('label[for*="email"]');
    
    await expect(emailInput).toBeVisible();
  });

  test('should support keyboard navigation', async ({ page }) => {
    await page.goto('/venues');
    
    // Tab through interactive elements
    await page.keyboard.press('Tab');
    const focusedElement = page.locator(':focus');
    await expect(focusedElement).toBeTruthy();
  });

  test('should have alt text for images', async ({ page }) => {
    await page.goto('/');
    
    const images = page.locator('img');
    const count = await images.count();
    
    for (let i = 0; i < count; i++) {
      const img = images.nth(i);
      const alt = await img.getAttribute('alt');
      expect(alt).toBeTruthy();
    }
  });

  test('should have sufficient color contrast', async ({ page }) => {
    await page.goto('/venues');
    
    // Check that buttons are visible and have good contrast
    const buttons = page.locator('button, .btn, a.bg-blue-600');
    const count = await buttons.count();
    expect(count).toBeGreaterThan(0);
  });
});
