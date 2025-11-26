"use client";

import '@testing-library/jest-dom/vitest'
import { render, screen } from '@testing-library/react'
import { describe, expect, test, vi } from 'vitest'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

vi.mock('next-intl', () => ({
  useTranslations: () => () => 'Map Title'
}))

vi.mock('@/components/map-3d', () => ({
  default: () => <div data-testid="mock-map">Mock Map</div>
}))

import Page from '../app/page'

describe('app/page', () => {
  test('renders map component', () => {
    const queryClient = new QueryClient()

    render(
      <QueryClientProvider client={queryClient}>
        <Page />
      </QueryClientProvider>
    )

    expect(screen.getByTestId('mock-map')).toBeInTheDocument()
  })
})
