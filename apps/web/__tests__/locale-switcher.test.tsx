"use client";

import { cleanup, render, screen } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import { useLocale } from 'next-intl'
import React from 'react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

import { AuthProvider } from '@/hooks/use-auth'

vi.mock('next-intl', () => {
  const mockUseLocale = vi.fn(() => 'en')
  return {
    useTranslations: (namespace: string) => {
      const messages: Record<string, Record<string, string>> = {
        LocaleSwitcher: { en: 'English', fi: 'Suomi', label: 'Language' }
      }
      return (key: string) => messages[namespace]?.[key] ?? `${namespace}.${key}`
    },
    useLocale: mockUseLocale
  }
})

vi.mock('@/i18n/locale', () => ({
  setUserLocale: vi.fn()
}))

import LocaleSwitcher from '../components/locale-switcher'
import { LocaleSwitcherSelect } from '../components/locale-switcher/locale-switcher-select'

const mockUseLocale = vi.mocked(useLocale)

beforeEach(() => {
  vi.clearAllMocks()
  mockUseLocale.mockReturnValue('en')
})

afterEach(() => {
  cleanup()
})

function renderWithProviders(ui: React.ReactNode) {
  const queryClient = new QueryClient()

  return render(
    <QueryClientProvider client={queryClient}>
      <AuthProvider
        isLoggedIn={false}
        user={null}
      >
        {ui}
      </AuthProvider>
    </QueryClientProvider>
  )
}

test('LocaleSwitcher shows translated current locale label for English', () => {
  mockUseLocale.mockReturnValue('en')
  renderWithProviders(<LocaleSwitcher />)

  const combobox = screen.getByRole('combobox')
  expect(combobox.textContent).toContain('English')
  expect(combobox.textContent).not.toContain('Suomi')
})

test('LocaleSwitcher shows translated current locale label for Finnish', () => {
  mockUseLocale.mockReturnValue('fi')
  renderWithProviders(<LocaleSwitcher />)

  const combobox = screen.getByRole('combobox')
  expect(combobox.textContent).toContain('Suomi')
  expect(combobox.textContent).not.toContain('English')
})

test('LocaleSwitcherSelect renders with correct default value and label', () => {
  renderWithProviders(
    <LocaleSwitcherSelect
      defaultValue="en"
      items={[
        { value: 'en', label: 'English' },
        { value: 'fi', label: 'Suomi' }
      ]}
      label="Language"
    />
  )

  const combobox = screen.getByRole('combobox')
  expect(combobox.textContent).toContain('English')
})
