import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';
import { type NextRequest, NextResponse } from 'next/server';
import { logoutAction } from '@/app/(auth)/actions';

export async function GET(request: NextRequest) {
  // Call the logout action to clear the session token
  await logoutAction();

  // Redirect to the home page
  redirect('/');
}
