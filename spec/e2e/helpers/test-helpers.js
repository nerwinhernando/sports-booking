const { expect } = require('@playwright/test');

class TestHelpers {
  constructor(page) {
    this.page = page;
  }

  async login(email, password) {
    await this.page.goto('/users/sign_in');
    await this.page.fill('input[name="user[email]"]', email);
    await this.page.fill('input[name="user[password]"]', password);
    await this.page.click('input[type="submit"]');
    await this.page.waitForLoadState('networkidle');
  }

  async logout() {
    await this.page.click('a:has-text("Sign Out")');
    await this.page.waitForLoadState('networkidle');
  }

  async registerUser(userData) {
    await this.page.goto('/users/sign_up');
    await this.page.fill('input[name="user[first_name]"]', userData.firstName);
    await this.page.fill('input[name="user[last_name]"]', userData.lastName);
    await this.page.fill('input[name="user[email]"]', userData.email);
    await this.page.fill('input[name="user[phone]"]', userData.phone);
    await this.page.fill('input[name="user[password]"]', userData.password);
    await this.page.fill('input[name="user[password_confirmation]"]', userData.password);
    await this.page.click('input[type="submit"]');
    await this.page.waitForLoadState('networkidle');
  }

  async selectDate(date) {
    const dateStr = date.toISOString().split('T')[0];
    await this.page.click(`a[href*="date=${dateStr}"]`);
    await this.page.waitForLoadState('networkidle');
  }

  async selectTimeSlot(time) {
    await this.page.click(`text=${time}`).first();
    await this.page.waitForLoadState('networkidle');
  }

  async fillBookingForm(paymentMethod, notes = '') {
    await this.page.selectOption('select[name="booking[payment_method]"]', paymentMethod);
    if (notes) {
      await this.page.fill('textarea[name="booking[notes]"]', notes);
    }
  }

  async submitBooking() {
    await this.page.click('input[type="submit"]:has-text("Confirm Booking")');
    await this.page.waitForLoadState('networkidle');
  }

  async expectToBeOnPage(path) {
    await expect(this.page).toHaveURL(new RegExp(path));
  }

  async expectToSeeText(text) {
    await expect(this.page.locator(`text=${text}`)).toBeVisible();
  }

  async expectNotToSeeText(text) {
    await expect(this.page.locator(`text=${text}`)).not.toBeVisible();
  }

  async waitForSuccess() {
    await this.page.waitForSelector('.bg-green-100, .alert-success', {
      timeout: 5000
    });
  }

  async waitForError() {
    await this.page.waitForSelector('.bg-red-100, .alert-danger', {
      timeout: 5000
    });
  }

  async takeScreenshot(name) {
    await this.page.screenshot({ 
      path: `test-results/screenshots/${name}.png`,
      fullPage: true 
    });
  }
}

module.exports = { TestHelpers };