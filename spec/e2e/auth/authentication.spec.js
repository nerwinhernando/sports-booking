const { test, expect } = require('@playwright/test');
const { TestHelpers } = require('../helpers/test-helpers');
const { TestFixtures } = require('../helpers/fixtures');

test.describe('Authentication', () => {
  let helpers;

  test.beforeEach(async ({ page }) => {
    helpers = new TestHelpers(page);
  });

  test('should display sign in page', async ({ page }) => {
    await page.goto('/users/sign_in');
    await expect(page.locator('h2')).toContainText('Sign in');
    await expect(page.locator('input[name="user[email]"]')).toBeVisible();
    await expect(page.locator('input[name="user[password]"]')).toBeVisible();
  });

  test('should sign in with valid credentials', async ({ page }) => {
    const user = TestFixtures.getAdminUser();
    
    await page.goto('http://metromanila.localhost:3000/users/sign_in');
    await helpers.login(user.email, user.password);
    
    await expect(page).toHaveURL(/.*metromanila/);
    await helpers.expectToSeeText('Admin');
  });

  test('should fail sign in with invalid credentials', async ({ page }) => {
    await page.goto('/users/sign_in');
    await helpers.login('wrong@example.com', 'wrongpassword');
    
    await helpers.expectToSeeText('Invalid Email or password');
  });

  test('should register new customer', async ({ page }) => {
    const userData = TestFixtures.getCustomerUser();
    
    await helpers.registerUser(userData);
    await helpers.expectToSeeText(userData.firstName);
  });

  test('should navigate to forgot password page', async ({ page }) => {
    await page.goto('/users/sign_in');
    await page.click('text=Forgot password?');
    
    await helpers.expectToBeOnPage('/users/password/new');
    await helpers.expectToSeeText('Forgot your password?');
  });

  test('should sign out successfully', async ({ page }) => {
    const user = TestFixtures.getAdminUser();
    
    await page.goto('http://metromanila.lvh.me:3000');
    await helpers.login(user.email, user.password);
    await helpers.logout();
    
    await helpers.expectToSeeText('Sign In');
  });

  test('should remember user when checkbox is checked', async ({ page }) => {
    const user = TestFixtures.getAdminUser();
    
    await page.goto('http://metromanila.lvh.me:3000/users/sign_in');
    await page.fill('input[name="user[email]"]', user.email);
    await page.fill('input[name="user[password]"]', user.password);
    await page.check('input[name="user[remember_me]"]');
    await page.click('input[type="submit"]');
    
    await page.waitForLoadState('networkidle');
    const cookies = await page.context().cookies();
    const rememberCookie = cookies.find(c => c.name.includes('remember'));
    expect(rememberCookie).toBeDefined();
  });
});
