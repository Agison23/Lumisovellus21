import { NextRequest, NextResponse } from 'next/server';

async function isValidToken(token: string): Promise<boolean> {
  return token.length > 0;
}

export function middleware(request: NextRequest) {
  console.log('in middleware');
  const sessionToken = request.cookies.get('sessionToken')?.value;

  if (
    (request.nextUrl.pathname === '/login' ||
      request.nextUrl.pathname === '/register') &&
    sessionToken
  ) {
    return NextResponse.redirect(new URL('/', request.url));
  }

  if (request.nextUrl.pathname.startsWith('/dashboard') && !sessionToken) {
    if (!sessionToken || !isValidToken(sessionToken)) {
      return NextResponse.redirect(new URL('/login', request.url));
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/login', '/register', '/dashboard/:path*'],
};
