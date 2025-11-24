import { paths } from "@lumisovellus/api-client-web";
import { NextRequest, NextResponse } from "next/server";
import { apiUrl } from "./lib/map/loaders";

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
async function verifyTokenWithUser(token: string) {
  try {
    const response = await fetch(`${apiUrl}/auth/verify-token`, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    });

    if (!response.ok) {
      return null;
    }
    type VerifyResponse =
      paths["/auth/verify-token"]["get"]["responses"]["200"]["content"]["application/json"];
    const result: VerifyResponse = await response.json();

    return result.data?.valid === true ? result.data?.user : null;
  } catch (error) {
    console.error("Token verification failed in middleware:", error);
    return null;
  }
}

function hasRouteAccess(
  pathname: string,
  userRole: string | undefined,
): boolean {
  // NORMAL users can only access /dashboard root
  if (userRole === "NORMAL") {
    return pathname === "/dashboard" || pathname === "/dashboard/";
  }

  // GUIDE and RESCUE can access segments and reports
  if (userRole === "GUIDE" || userRole === "RESCUE") {
    return (
      pathname === "/dashboard" ||
      pathname.startsWith("/dashboard/segments") ||
      pathname.startsWith("/dashboard/reports")
    );
  }

  // ADMIN can access everything under /dashboard
  if (userRole === "ADMIN") {
    return pathname.startsWith("/dashboard");
  }

  return false;
}

export async function middleware(request: NextRequest) {
  const accessToken = request.cookies.get("accessToken")?.value;
  const refreshToken = request.cookies.get("refreshToken")?.value;
  const pathname = request.nextUrl.pathname;

  if ((pathname === "/login" || pathname === "/register") && accessToken) {
    const isValid = await verifyToken(accessToken);
    if (isValid) {
      return NextResponse.redirect(new URL("/", request.url));
    }
  }

  // Protect dashboard routes
  if (pathname.startsWith("/dashboard")) {
    if (!accessToken && !refreshToken) {
      return NextResponse.redirect(new URL("/login", request.url));
    }

    if (accessToken) {
      const user = await verifyTokenWithUser(accessToken);
      if (!user) {
        return NextResponse.redirect(new URL("/login", request.url));
      }

      if (!hasRouteAccess(pathname, user.role)) {
        return NextResponse.redirect(new URL("/dashboard", request.url));
      }
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: ["/login", "/register", "/dashboard/:path*"],
};
