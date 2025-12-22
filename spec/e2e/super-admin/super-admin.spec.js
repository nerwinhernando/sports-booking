const { test, expect } = require('@playwright/test');
const { TestHelpers } = require('../helpers/test-helpers');
const { TestFixtures } = require('../helpers/fixtures');

test.describe('Super Admin', () => {
  let helpers;

  test.beforeEach(async ({ page }) => {
    helpers = new TestHelpers(page);
    const superAdmin = TestFixtures.getSuperAdminUser();
    
    await page.goto('http://localhost:3000');
    await helpers.login(superAdmin.email, superAdmin.password);
  });

  test('should access super admin dashboard', async ({ page }) => {
    await page.goto('http://localhost:3000/super_admin');
    
    await helpers.expectToSeeText('Accounts');
    await expect(page).toHaveURL(/.*super_admin/);
  });

  test('should view all accounts', async ({ page }) => {
    await page.goto('http://localhost:3000/super_admin/accounts');
    
    await helpers.expectToSeeText('Accounts');
    await expect(page.locator('table, .collection')).toBeVisible();
  });

  test('should view account details', async ({ page }) => {
    await page.goto('http://localhost:3000/super_admin/accounts');
    
    const firstAccount = page.locator('a[href*="/super_admin/accounts/"]').first();
    await firstAccount.click();
    await page.waitForLoadState('networkidle');
    
    await helpers.expectToSeeText('Subdomain');
    await helpers.expectToSeeText('Plan');
  });

  test('should view all users across accounts', async ({ page }) => {
    await page.goto('http://localhost:3000/super_admin/users');
    
    await helpers.expectToSeeText('Users');
    await expect(page.locator('table, .collection')).toBeVisible();
  });

  test('should filter users by role', async ({ page }) => {
    await page.goto('http://localhost:3000/super_admin/users');
    
    const roleFilter = page.locator('select[name="role"]');
    if (await roleFilter.isVisible()) {
      await roleFilter.selectOption('admin');
      await page.waitForLoadState('networkidle');
    }
  });

  test('should not allow regular users to access super admin', async ({ page, context }) => {
    await helpers.logout();
    
    const customer = TestFixtures.getCustomerUser();
    await helpers.registerUser(customer);
    
    await page.goto('http://localhost:3000/super_admin');
    
    await helpers.expectToSeeText('Access denied');
  });
});
