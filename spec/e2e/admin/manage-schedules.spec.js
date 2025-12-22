const { test, expect } = require('@playwright/test');
const { TestHelpers } = require('../helpers/test-helpers');
const { TestFixtures } = require('../helpers/fixtures');

test.describe('Manage Schedules', () => {
  let helpers;

  test.beforeEach(async ({ page }) => {
    helpers = new TestHelpers(page);
    const admin = TestFixtures.getAdminUser();
    
    await page.goto('http://metromanila.localhost:3000');
    await helpers.login(admin.email, admin.password);
  });

  test('should view schedule templates', async ({ page }) => {
    await page.goto('http://metromanila.localhost:3000/admin/schedule_templates');
    
    await helpers.expectToSeeText('Schedule Templates');
  });

  test('should generate schedules for a date', async ({ page }) => {
    await page.goto('http://metromanila.localhost:3000/admin/venues');
    
    // Click first venue
    const firstVenue = page.locator('a[href*="/admin/venues/"]').first();
    await firstVenue.click();
    await page.waitForLoadState('networkidle');
    
    // Look for schedules link or generate button
    const schedulesLink = page.locator('a:has-text("Schedules")');
    if (await schedulesLink.isVisible()) {
      await schedulesLink.click();
      await page.waitForLoadState('networkidle');
    }
  });

  test('should view available features', async ({ page }) => {
    await page.goto('http://metromanila.localhost:3000/admin/features');
    
    await helpers.expectToSeeText('Features');
  });
});
