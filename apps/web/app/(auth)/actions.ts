"use server";

import type { paths } from "@lumisovellus/api-client-web";
import { revalidatePath } from "next/cache";
import { cookies } from "next/headers";
import { apiUrl } from "@/lib/map/loaders";

export async function loginAction(email: string, password: string) {
  // Call your backend API here
  type LoginBody =
    paths["/auth/login"]["post"]["requestBody"]["content"]["application/json"];
  const loginData: LoginBody = { email, password };

  console.log("Logging in with:", loginData);
  console.log("POSTING TO:", `${apiUrl}/auth/login`);

  const response = await fetch(`${apiUrl}/auth/login`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(loginData),
  });

  if (!response.ok) {
    throw new Error("Login failed");
  }
  type LoginResponse =
    paths["/auth/login"]["post"]["responses"]["200"]["content"]["application/json"];
  const { data }: LoginResponse = await response.json();
  const accessToken = data.accessToken;
  const refreshToken = data.refreshToken;
  const user: LoginResponse["data"]["user"] = data.user;

  const cookieStore = await cookies();
  cookieStore.set("accessToken", accessToken, {
    path: "/",
    maxAge: 60 * 60 * 24 * 7,
    secure: true,
    httpOnly: true,
    sameSite: "strict",
  });
  cookieStore.set("refreshToken", refreshToken, {
    path: "/",
    maxAge: 60 * 60 * 24 * 7,
    secure: true,
    httpOnly: true,
    sameSite: "strict",
  });

  revalidatePath("/");
  return { success: true };
}

export async function logoutAction() {
  const cookieStore = await cookies();
  // we need to post to /auth/logout with accessToken as authorization header
  const accessToken = cookieStore.get("accessToken")?.value;

  if (accessToken) {
    const res = await fetch(`${apiUrl}/auth/logout`, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
    });

    type LogoutResponse =
      paths["/auth/logout"]["post"]["responses"]["200"]["content"]["application/json"];
    if (res.ok) {
      const result: LogoutResponse = await res.json();
      console.log("Logout response:", result);
    } else {
      console.error("Logout failed with status:", res.status);
    }
  }
  cookieStore.delete("accessToken");
  cookieStore.delete("refreshToken");

  revalidatePath("/");
  return { success: true };
}

export async function verifyTokenAction(token: string) {
  try {
    const response = await fetch(`${apiUrl}/auth/verify-token`, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    });
    if (!response.ok) {
      return { valid: false, user: null };
    }

    type VerifyResponse =
      paths["/auth/verify-token"]["get"]["responses"]["200"]["content"]["application/json"];
    const result: VerifyResponse = await response.json();
    return { valid: result.data.valid, user: result.data.user || null };
  } catch (error) {
    console.error("Token verification failed:", error);
    return { valid: false, user: null };
  }
}

export async function refreshTokenAction() {
  const cookieStore = await cookies();
  const refreshToken = cookieStore.get("refreshToken")?.value;

  if (!refreshToken) {
    return { success: false };
  }

  try {
    type RefreshBody =
      paths["/auth/refresh-token"]["post"]["requestBody"]["content"]["application/json"];
    const requestBody: RefreshBody = { refreshToken };

    const response = await fetch(`${apiUrl}/auth/refresh-token`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestBody),
    });

    if (!response.ok) {
      return { success: false };
    }

    type RefreshResponse =
      paths["/auth/refresh-token"]["post"]["responses"]["200"]["content"]["application/json"];
    const { data }: RefreshResponse = await response.json();

    cookieStore.set("accessToken", data.accessToken, {
      path: "/",
      maxAge: 60 * 60 * 24 * 7,
      secure: process.env.NODE_ENV === "production",
      httpOnly: true,
      sameSite: "strict",
    });
    cookieStore.set("refreshToken", data.refreshToken, {
      path: "/",
      maxAge: 60 * 60 * 24 * 30,
      secure: process.env.NODE_ENV === "production",
      httpOnly: true,
      sameSite: "strict",
    });

    revalidatePath("/");
    return { success: true, user: data.user };
  } catch (error) {
    console.error("Token refresh failed:", error);
    return { success: false };
  }
}

export async function registerAction(email: string, password: string) {
  // Call your backend API here to register the user
  console.log("Registering user:", email);
  return true;
}

export async function getAccessTokenAction() {
  const cookieStore = await cookies();
  return cookieStore.get("accessToken")?.value || null;
}
