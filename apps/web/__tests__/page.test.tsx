"use client";

import '@testing-library/jest-dom/vitest'

import { render } from '@testing-library/react'
import { describe, expect, test, vi } from 'vitest'

vi.mock('next-intl', () => ({
  useTranslations: () => () => 'Map Title'
}))

import Page from '../app/page'

describe('app/page', () => {
  test('renders without errors', () => {
    const { container } = render(<Page />)
    
    // Page now returns null as map is rendered in layout via PersistentMap
    expect(container.firstChild).toBeNull()
  })
})
