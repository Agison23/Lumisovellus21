"use server";

import type { paths } from "@lumisovellus/api-client-web";
import { revalidatePath } from "next/cache";
import { cookies } from "next/headers";
import { serverApiUrl } from "@/lib/map/loaders";

export async function loginAction(email: string, password: string) {
  // Call your backend API here
  type LoginBody =
    paths["/auth/login"]["post"]["requestBody"]["content"]["application/json"];
  const loginData: LoginBody = { email, password };

  const response = await fetch(`${serverApiUrl}/auth/login`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(loginData),
  });

  if (!response.ok) {
    // match the error response type
    type ErrorResponse =
      paths["/auth/login"]["post"]["responses"]["400"]["content"]["application/json"];
    const errorData: ErrorResponse = await response.json();
    throw new Error(errorData.error.message || "Login failed");
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
    const res = await fetch(`${serverApiUrl}/auth/logout`, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
    });

    type LogoutResponse =
      paths["/auth/logout"]["post"]["responses"]["200"]["content"]["application/json"];
    if (!res.ok) {
      throw new Error("Logout failed");
    }
  }
  cookieStore.delete("accessToken");
  cookieStore.delete("refreshToken");

  revalidatePath("/");
  return { success: true };
}

export async function verifyTokenAction(token: string) {
  try {
    const response = await fetch(`${serverApiUrl}/auth/verify-token`, {
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

    const response = await fetch(`${serverApiUrl}/auth/refresh-token`, {
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
    return { success: true };
  } catch (error) {
    console.error("Token refresh failed:", error);
    return { success: false };
  }
}

export async function registerAction(
  firstName: string,
  lastName: string | undefined,
  email: string,
  password: string,
) {
  type RegisterBody =
    paths["/auth/register"]["post"]["requestBody"]["content"]["application/json"];
  const requestBody: RegisterBody = { firstName, lastName, email, password };

  const response = await fetch(`${serverApiUrl}/auth/register`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(requestBody),
  });

  if (!response.ok) {
    // match the error response type
    type ErrorResponse =
      paths["/auth/register"]["post"]["responses"]["400"]["content"]["application/json"];
    const errorData: ErrorResponse = await response.json();
    throw new Error(errorData.error.message || "Registration failed");
  }

  type RegisterResponse =
    paths["/auth/register"]["post"]["responses"]["201"]["content"]["application/json"];
  const { data }: RegisterResponse = await response.json();

  const cookieStore = await cookies();
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
  return true;
}

export async function getAccessTokenAction() {
  const cookieStore = await cookies();
  return cookieStore.get("accessToken")?.value || null;
}
