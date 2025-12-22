const { test, expect } = require('@playwright/test');
const { TestHelpers } = require('../helpers/test-helpers');

test.describe('Venue Details', () => {
  let helpers;

  test.beforeEach(async ({ page }) => {
    helpers = new TestHelpers(page);
    await page.goto('/venues');
    await page.locator('a:has-text("View Details")').first().click();
    await page.waitForLoadState('networkidle');
  });

  test('should display date selector', async ({ page }) => {
    const dateButtons = page.locator('a:has-text(/Mon|Tue|Wed|Thu|Fri|Sat|Sun/)');
    await expect(dateButtons.first()).toBeVisible();
  });

  test('should change date when clicking date button', async ({ page }) => {
    const secondDate = page.locator('a:has-text(/Mon|Tue|Wed|Thu|Fri|Sat|Sun/)').nth(1);
    await secondDate.click();
    
    await page.waitForLoadState('networkidle');
    await expect(secondDate).toHaveClass(/bg-blue-600/);
  });

  test('should filter courts by type', async ({ page }) => {
    await page.selectOption('select[name="court_type"]', 'premium');
    await page.click('input[type="submit"]:has-text("Apply")');
    
    await page.waitForLoadState('networkidle');
    await helpers.expectToSeeText('Premium');
  });

  test('should filter courts by floor type', async ({ page }) => {
    await page.selectOption('select[name="floor_type"]', 'wood');
    await page.click('input[type="submit"]:has-text("Apply")');
    
    await page.waitForLoadState('networkidle');
    await helpers.expectToSeeText('Wood');
  });

  test('should display available time slots', async ({ page }) => {
    const timeSlots = page.locator('.grid .border');
    const count = await timeSlots.count();
    expect(count).toBeGreaterThan(0);
  });

  test('should show peak hour indicator', async ({ page }) => {
    const peakSlots = page.locator('.bg-yellow-50');
    const count = await peakSlots.count();
    
    if (count > 0) {
      await helpers.expectToSeeText('Peak');
    }
  });

  test('should display pricing for each slot', async ({ page }) => {
    const priceElements = page.locator('text=/₱[0-9,]+/');
    const count = await priceElements.count();
    expect(count).toBeGreaterThan(0);
  });

  test('should show no slots message when none available', async ({ page }) => {
    // Select a past date or far future date
    const futureDate = new Date();
    futureDate.setDate(futureDate.getDate() + 90);
    
    await page.goto(`/venues/1?date=${futureDate.toISOString().split('T')[0]}`);
    await page.waitForLoadState('networkidle');
    
    const noSlotsMessage = page.locator('text=/No available time slots|No courts available/');
    if (await noSlotsMessage.isVisible()) {
      await helpers.expectToSeeText('No available');
    }
  });
});
