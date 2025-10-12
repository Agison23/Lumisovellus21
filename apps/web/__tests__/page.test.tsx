
import { render, screen } from '@testing-library/react'
import { describe, expect, test, vi } from 'vitest'
import { useTranslations } from 'next-intl'

vi.mock('next-intl', () => ({
  useTranslations: (namespace: string) => {
    const messages: Record<string, Record<string, string>> = {
      MapPage: { title: 'Map Title', loading: 'Loading...' }
    }
    return (key: string) => messages[namespace]?.[key] ?? `${namespace}.${key}`
  }
}))

import Page from '../app/page'
describe('app/page', () => {
  test('renders translated title, loading text and About link', () => {
    render(<Page />)

    // heading (h1) should be the translated title
    const heading = screen.getByRole('heading', { level: 1 })
    expect(heading.textContent).toBe('Map Title')

    // paragraph should have translated loading text
    expect(screen.getByText('Loading...')).toBeTruthy()

    // Link to About should be present and point to /about
    const aboutLink = screen.getByRole('link', { name: /About/i })
    expect(aboutLink.getAttribute('href')).toBe('/about')
  })
})
