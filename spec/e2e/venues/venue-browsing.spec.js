const { test, expect } = require('@playwright/test');
const { TestHelpers } = require('../helpers/test-helpers');
const { TestFixtures } = require('../helpers/fixtures');

test.describe('Venue Browsing', () => {
  let helpers;

  test.beforeEach(async ({ page }) => {
    helpers = new TestHelpers(page);
  });

  test('should display all venues on index page', async ({ page }) => {
    await page.goto('/venues');
    
    await helpers.expectToSeeText('Find Courts');
    await helpers.expectToSeeText('Available Venues');
    await expect(page.locator('.grid')).toBeVisible();
  });

  test('should filter venues by province', async ({ page }) => {
    await page.goto('/venues');
    
    await page.selectOption('select[name="province"]', 'Metro Manila');
    await page.click('input[type="submit"]:has-text("Apply Filters")');
    
    await page.waitForLoadState('networkidle');
    await helpers.expectToSeeText('Metro Manila');
  });

  test('should filter venues by city', async ({ page }) => {
    await page.goto('/venues');
    
    await page.selectOption('select[name="city"]', 'Quezon City');
    await page.click('input[type="submit"]:has-text("Apply Filters")');
    
    await page.waitForLoadState('networkidle');
    await helpers.expectToSeeText('Quezon City');
  });

  test('should filter venues by court type', async ({ page }) => {
    await page.goto('/venues');
    
    await page.selectOption('select[name="court_type"]', 'premium');
    await page.click('input[type="submit"]:has-text("Apply Filters")');
    
    await page.waitForLoadState('networkidle');
    await helpers.expectToSeeText('Premium');
  });

  test('should filter venues with air conditioning', async ({ page }) => {
    await page.goto('/venues');
    
    await page.check('input[name="aircon"]');
    await page.click('input[type="submit"]:has-text("Apply Filters")');
    
    await page.waitForLoadState('networkidle');
    await helpers.expectToSeeText('Air Conditioned');
  });

  test('should clear all filters', async ({ page }) => {
    await page.goto('/venues');
    
    await page.selectOption('select[name="province"]', 'Metro Manila');
    await page.selectOption('select[name="court_type"]', 'premium');
    await page.click('input[type="submit"]:has-text("Apply Filters")');
    
    await page.waitForLoadState('networkidle');
    await page.click('text=Clear');
    
    await page.waitForLoadState('networkidle');
    await expect(page.locator('select[name="province"]')).toHaveValue('');
  });

  test('should view venue details', async ({ page }) => {
    await page.goto('/venues');
    
    const firstVenue = page.locator('a:has-text("View Details")').first();
    await firstVenue.click();
    
    await page.waitForLoadState('networkidle');
    await helpers.expectToSeeText('Select Date');
    await helpers.expectToSeeText('Available Courts');
  });

  test('should display venue contact information', async ({ page }) => {
    await page.goto('/venues');
    
    await page.locator('a:has-text("View Details")').first().click();
    await page.waitForLoadState('networkidle');
    
    await expect(page.locator('text=/Phone:|📞/')).toBeVisible();
    await expect(page.locator('text=/Address:|📍/')).toBeVisible();
  });

  test('should show court features', async ({ page }) => {
    await page.goto('/venues');
    
    await page.locator('a:has-text("View Details")').first().click();
    await page.waitForLoadState('networkidle');
    
    const courtCard = page.locator('.bg-white').first();
    await expect(courtCard).toBeVisible();
  });
});
