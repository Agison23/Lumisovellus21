import { NextRequest, NextResponse } from "next/server";
import { apiUrl } from "./lib/map/loaders";
import { paths } from "@lumisovellus/api-client-web";

async function isValidToken(token: string): Promise<boolean> {
  return token.length > 0;
}
async function verifyToken(token: string): Promise<boolean> {
  try {
    const response = await fetch(`${apiUrl}/auth/verify-token`, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    });

    if (!response.ok) {
      return false;
    }
    type VerifyResponse =
      paths["/auth/verify-token"]["get"]["responses"]["200"]["content"]["application/json"];
    const result: VerifyResponse = await response.json();

    return result.data?.valid === true;
  } catch (error) {
    console.error("Token verification failed in middleware:", error);
    return false;
  }
}

export async function middleware(request: NextRequest) {
  const accessToken = request.cookies.get("accessToken")?.value;
  const refreshToken = request.cookies.get("refreshToken")?.value;

  if (
    (request.nextUrl.pathname === "/login" ||
      request.nextUrl.pathname === "/register") &&
    accessToken
  ) {
    const isValid = await verifyToken(accessToken);
    if (isValid) {
      return NextResponse.redirect(new URL("/", request.url));
    }
  }

  // Protect dashboard routes
  if (request.nextUrl.pathname.startsWith("/dashboard")) {
    if (!accessToken && !refreshToken) {
      return NextResponse.redirect(new URL("/login", request.url));
    }

    if (accessToken) {
      const isValid = await verifyToken(accessToken);
      if (!isValid && !refreshToken) {
        return NextResponse.redirect(new URL("/login", request.url));
      }
      // If token is invalid but we have refreshToken, let the request through
      // The server will handle refreshing via the action
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: ["/login", "/register", "/dashboard/:path*"],
};
