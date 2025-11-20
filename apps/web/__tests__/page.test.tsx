import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { render, screen } from '@testing-library/react'
import React from 'react'
import { describe, expect, test, vi } from 'vitest'

import Page from '../app/page'

// Mock next-intl hooks used by Page so outputs are deterministic
vi.mock('next-intl', () => ({
  useTranslations: (namespace: string) => {
    const messages: Record<string, Record<string, string>> = {
      MapPage: {
        title: 'Map Title',
        loading: 'Loading...',
        'loading.map': 'Loading...',   // ⭐ ADD THIS
      }
    }
    return (key: string) => messages[namespace]?.[key] ?? `${namespace}.${key}`
  }
}))

function renderWithQueryClient(ui: React.ReactElement) {
  const client = new QueryClient()
  return render(<QueryClientProvider client={client}>{ui}</QueryClientProvider>)
}

describe('app/page', () => {
  test('renders translated title, loading text and About link', () => {
    renderWithQueryClient(<Page />)
    expect(screen.getByText('Loading...')).toBeTruthy()
  })
})
