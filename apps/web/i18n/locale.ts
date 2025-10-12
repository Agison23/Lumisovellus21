'use server'
import { cookies } from "next/headers";
// eslint-disable-next-line @typescript-eslint/no-unused-vars, unused-imports/no-unused-imports
import { defaultLocale, Locale } from "./config";

const COOKIE_NAME = 'NEXT_LOCALE';

export async function getUserLocale() {
  return (await cookies()).get(COOKIE_NAME)?.value || defaultLocale;
}

export async function setUserLocale(locale: Locale) {
  (await cookies()).set(COOKIE_NAME, locale);
}
