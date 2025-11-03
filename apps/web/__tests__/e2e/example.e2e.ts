import { test, expect } from '@playwright/test'

test('should navigate to the weather page', async ({ page }) => {
  await page.goto('http://localhost:3000/')
  
  // Wait for the navigation to be loaded and stable
  await page.waitForLoadState('networkidle')
  await page.waitForSelector('[data-slot="navigation-menu"]', { state: 'visible' })
  
  // Use a more specific selector for the Weather link
  const weatherLink = page.locator('[data-slot="navigation-menu"] a').filter({ hasText: 'Weather' })
  await weatherLink.waitFor({ state: 'visible' })
  await weatherLink.click()
  
  // Wait for navigation to complete
  await page.waitForURL('**/weather')
  await expect(page).toHaveURL(/\/weather$/)
  
  // Verify the weather page content is displayed
  await expect(page.locator('h1')).toContainText('Weather')
})

test('should navigate to the definitions page', async ({ page }) => {
  await page.goto('http://localhost:3000/')
  
  // Wait for the page to be fully loaded
  await page.waitForLoadState('networkidle')
  await page.waitForSelector('[data-slot="navigation-menu"]', { state: 'visible' })
  
  // Use a more specific selector for the Definitions link
  const definitionsLink = page.locator('[data-slot="navigation-menu"] a').filter({ hasText: 'Definitions' })
  await definitionsLink.waitFor({ state: 'visible' })
  await definitionsLink.click()
  
  // Wait for navigation to complete
  await page.waitForURL('**/definitions')
  await expect(page).toHaveURL(/\/definitions$/)
  
  // Verify the definitions page content is displayed
  await expect(page.locator('h1')).toContainText('Definitions')
})

test('should navigate to map page', async ({ page }) => {
  await page.goto('http://localhost:3000/weather')
  
  // Wait for the page to be fully loaded
  await page.waitForLoadState('networkidle')
  await page.waitForSelector('[data-slot="navigation-menu"]', { state: 'visible' })
  
  // Use a more specific selector for the Map link
  const mapLink = page.locator('[data-slot="navigation-menu"] a').filter({ hasText: 'Map' })
  await mapLink.waitFor({ state: 'visible' })
  await mapLink.click()
  
  // Wait for navigation to complete
  await page.waitForURL('http://localhost:3000/')
  await expect(page).toHaveURL('http://localhost:3000/')
})

test('should show sidebar and toggle it', async ({ page }) => {
  await page.goto('http://localhost:3000/')
  
  // Wait for the page to be fully loaded
  await page.waitForLoadState('networkidle')
  
  // Wait for the sidebar trigger and ensure it's interactive
  const sidebarTrigger = page.locator('[data-slot="sidebar-trigger"]')
  await sidebarTrigger.waitFor({ state: 'visible' })
  
  // Check if sidebar content is visible initially
  const sidebarTitle = page.locator('text=Pallaksen Pöllöt')
  const isInitiallyVisible = await sidebarTitle.isVisible()
  
  // Click the sidebar trigger
  await sidebarTrigger.click()
  
  // Wait a moment for the animation to complete
  await page.waitForTimeout(500)
  
  // Verify the sidebar state changed
  if (isInitiallyVisible) {
    await expect(sidebarTitle).not.toBeVisible()
  } else {
    await expect(sidebarTitle).toBeVisible()
  }
})

test('should change language using locale switcher', async ({ page }) => {
  await page.goto('http://localhost:3000/')
  
  // Wait for the page to be fully loaded
  await page.waitForLoadState('networkidle')
  
  // Find and click the locale switcher trigger
  const selectTrigger = page.locator('[data-slot="select-trigger"]')
  await selectTrigger.waitFor({ state: 'visible' })
  await selectTrigger.click()
  
  // Wait for the dropdown to appear and click Finnish option
  await page.waitForSelector('text=Suomi', { state: 'visible' })
  await page.click('text=Suomi')
  
  // Wait for the page to reload/update
  await page.waitForLoadState('networkidle')
  
  // Verify that the navigation shows Finnish text
  await expect(page.locator('text=Kartta')).toBeVisible({ timeout: 10000 })
})

test('should interact with map areas', async ({ page }) => {
  await page.goto('http://localhost:3000/')
  
  // Wait for the page to be fully loaded
  await page.waitForLoadState('networkidle')
  
  // Wait for the map to load completely with a longer timeout
  await page.waitForSelector('.maplibregl-canvas', { timeout: 15000, state: 'visible' })
  
  // Wait for any loading indicators to disappear
  await page.waitForFunction(() => {
    // Playwright selector syntax like 'text=Loading map...' cannot be used inside page scripts;
    // check the page's text content instead and resolve when the loading text is gone.
    return !document.body || !document.body.innerText.includes('Loading map...')
  }, { timeout: 15000 }).catch(() => {
    // If the loading text check doesn't work, just continue
    console.log('Loading text not found or already hidden')
  })
  
  // Wait a bit more for map to be fully interactive
  await page.waitForTimeout(2000)
  
  // Click somewhere on the map canvas to test interaction
  const mapCanvas = page.locator('.maplibregl-canvas')
  await mapCanvas.click({ position: { x: 400, y: 300 }, force: true })
  
  // Check if any selection indicator appears (adjust based on your actual UI)
  await expect(page.locator('text=Selected:').or(page.locator('[data-testid="selection-info"]'))).toBeVisible({ timeout: 5000 })
})