'use server';

import { revalidatePath } from 'next/cache';
import { cookies } from 'next/headers';

export async function loginAction(email: string, password: string) {
  // Call your backend API here
  const token = 'fake-session-token';

  const cookieStore = await cookies();
  cookieStore.set('sessionToken', token, {
    path: '/',
    maxAge: 60 * 60 * 24 * 7,
    secure: true,
    httpOnly: true,
    sameSite: 'strict',
  });

  revalidatePath('/');
  return { success: true };
}

export async function logoutAction() {
  const cookieStore = await cookies();
  cookieStore.set('sessionToken', '', {
    path: '/',
    maxAge: 0,
    secure: true,
    httpOnly: true,
    sameSite: 'strict',
  });

  revalidatePath('/');
  return { success: true };
}
