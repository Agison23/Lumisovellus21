import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import {
  loginAction,
  logoutAction,
  verifyTokenAction,
  refreshTokenAction,
  registerAction,
  getAccessTokenAction,
} from "@/app/(auth)/actions";

// Mock next/cache
vi.mock("next/cache", () => ({
  revalidatePath: vi.fn(),
}));

// Mock next/headers
const mockCookieStore = {
  get: vi.fn(),
  set: vi.fn(),
  delete: vi.fn(),
};

vi.mock("next/headers", () => ({
  cookies: vi.fn(() => Promise.resolve(mockCookieStore)),
}));

// Mock fetch
global.fetch = vi.fn();

describe("Auth Actions", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  afterEach(() => {
    vi.clearAllMocks();
  });

  describe("loginAction", () => {
    it("should successfully login and set cookies", async () => {
      const mockResponse = {
        ok: true,
        json: vi.fn().mockResolvedValue({
          data: {
            accessToken: "access_token_123",
            refreshToken: "refresh_token_456",
            user: { id: "user_1", email: "test@example.com" },
          },
        }),
      };

      global.fetch = vi.fn().mockResolvedValue(mockResponse);

      const result = await loginAction("test@example.com", "password123");

      expect(result).toEqual({ success: true });
      expect(mockCookieStore.set).toHaveBeenCalledWith(
        "accessToken",
        "access_token_123",
        expect.any(Object),
      );
      expect(mockCookieStore.set).toHaveBeenCalledWith(
        "refreshToken",
        "refresh_token_456",
        expect.any(Object),
      );
    });

    it("should throw error on failed login", async () => {
      const mockResponse = {
        ok: false,
        json: vi.fn().mockResolvedValue({
          error: { message: "Invalid credentials" },
        }),
      };

      global.fetch = vi.fn().mockResolvedValue(mockResponse);

      await expect(
        loginAction("test@example.com", "wrong_password"),
      ).rejects.toThrow("Invalid credentials");
    });

    it("should throw error with default message when API doesn't return message", async () => {
      const mockResponse = {
        ok: false,
        json: vi.fn().mockResolvedValue({ error: {} }),
      };

      global.fetch = vi.fn().mockResolvedValue(mockResponse);

      await expect(
        loginAction("test@example.com", "wrong_password"),
      ).rejects.toThrow("Login failed");
    });

    it("should handle network errors", async () => {
      global.fetch = vi.fn().mockRejectedValue(new Error("Network error"));

      await expect(
        loginAction("test@example.com", "password123"),
      ).rejects.toThrow("Network error");
    });
  });

  describe("logoutAction", () => {
    it("should successfully logout and clear cookies", async () => {
      mockCookieStore.get.mockReturnValue({ value: "access_token_123" });

      const mockResponse = {
        ok: true,
        json: vi.fn().mockResolvedValue({}),
      };

      global.fetch = vi.fn().mockResolvedValue(mockResponse);

      const result = await logoutAction();

      expect(result).toEqual({ success: true });
      expect(mockCookieStore.delete).toHaveBeenCalledWith("accessToken");
      expect(mockCookieStore.delete).toHaveBeenCalledWith("refreshToken");
    });

    it("should clear cookies even if no accessToken exists", async () => {
      mockCookieStore.get.mockReturnValue(undefined);

      const result = await logoutAction();

      expect(result).toEqual({ success: true });
      expect(mockCookieStore.delete).toHaveBeenCalledWith("accessToken");
      expect(mockCookieStore.delete).toHaveBeenCalledWith("refreshToken");
    });

    it("should throw error if logout API fails", async () => {
      mockCookieStore.get.mockReturnValue({ value: "access_token_123" });

      const mockResponse = {
        ok: false,
      };

      global.fetch = vi.fn().mockResolvedValue(mockResponse);

      await expect(logoutAction()).rejects.toThrow("Logout failed");
    });
  });

  describe("verifyTokenAction", () => {
    it("should return valid token with user data", async () => {
      const mockUser = { id: "user_1", email: "test@example.com" };
      const mockResponse = {
        ok: true,
        json: vi.fn().mockResolvedValue({
          data: { valid: true, user: mockUser },
        }),
      };

      global.fetch = vi.fn().mockResolvedValue(mockResponse);

      const result = await verifyTokenAction("token_123");

      expect(result).toEqual({ valid: true, user: mockUser });
    });

    it("should return invalid for failed response", async () => {
      const mockResponse = {
        ok: false,
      };

      global.fetch = vi.fn().mockResolvedValue(mockResponse);

      const result = await verifyTokenAction("invalid_token");

      expect(result).toEqual({ valid: false, user: null });
    });

    it("should handle network errors gracefully", async () => {
      global.fetch = vi.fn().mockRejectedValue(new Error("Network error"));

      const result = await verifyTokenAction("token_123");

      expect(result).toEqual({ valid: false, user: null });
    });

    it("should return null user when API doesn't return user data", async () => {
      const mockResponse = {
        ok: true,
        json: vi.fn().mockResolvedValue({
          data: { valid: true, user: undefined },
        }),
      };

      global.fetch = vi.fn().mockResolvedValue(mockResponse);

      const result = await verifyTokenAction("token_123");

      expect(result).toEqual({ valid: true, user: null });
    });
  });

  describe("refreshTokenAction", () => {
    it("should successfully refresh tokens", async () => {
      mockCookieStore.get.mockReturnValue({ value: "refresh_token_456" });

      const mockResponse = {
        ok: true,
        json: vi.fn().mockResolvedValue({
          data: {
            accessToken: "new_access_token",
            refreshToken: "new_refresh_token",
          },
        }),
      };

      global.fetch = vi.fn().mockResolvedValue(mockResponse);

      const result = await refreshTokenAction();

      expect(result).toEqual({ success: true });
      expect(mockCookieStore.set).toHaveBeenCalledWith(
        "accessToken",
        "new_access_token",
        expect.any(Object),
      );
      expect(mockCookieStore.set).toHaveBeenCalledWith(
        "refreshToken",
        "new_refresh_token",
        expect.any(Object),
      );
    });

    it("should return false if no refresh token exists", async () => {
      mockCookieStore.get.mockReturnValue(undefined);

      const result = await refreshTokenAction();

      expect(result).toEqual({ success: false });
      expect(global.fetch).not.toHaveBeenCalled();
    });

    it("should return false on API error", async () => {
      mockCookieStore.get.mockReturnValue({ value: "refresh_token_456" });

      const mockResponse = {
        ok: false,
      };

      global.fetch = vi.fn().mockResolvedValue(mockResponse);

      const result = await refreshTokenAction();

      expect(result).toEqual({ success: false });
    });

    it("should handle network errors gracefully", async () => {
      mockCookieStore.get.mockReturnValue({ value: "refresh_token_456" });

      global.fetch = vi.fn().mockRejectedValue(new Error("Network error"));

      const result = await refreshTokenAction();

      expect(result).toEqual({ success: false });
    });
  });

  describe("registerAction", () => {
    it("should successfully register and set cookies", async () => {
      const mockResponse = {
        ok: true,
        json: vi.fn().mockResolvedValue({
          data: {
            accessToken: "access_token_123",
            refreshToken: "refresh_token_456",
            user: { id: "user_1", email: "newuser@example.com" },
          },
        }),
      };

      global.fetch = vi.fn().mockResolvedValue(mockResponse);

      const result = await registerAction(
        "John",
        "Doe",
        "newuser@example.com",
        "password123",
      );

      expect(result).toBe(true);
      expect(mockCookieStore.set).toHaveBeenCalledWith(
        "accessToken",
        "access_token_123",
        expect.any(Object),
      );
    });

    it("should support registration without last name", async () => {
      const mockResponse = {
        ok: true,
        json: vi.fn().mockResolvedValue({
          data: {
            accessToken: "access_token_123",
            refreshToken: "refresh_token_456",
            user: { id: "user_1", email: "newuser@example.com" },
          },
        }),
      };

      global.fetch = vi.fn().mockResolvedValue(mockResponse);

      const result = await registerAction(
        "John",
        undefined,
        "newuser@example.com",
        "password123",
      );

      expect(result).toBe(true);
    });

    it("should throw error on failed registration", async () => {
      const mockResponse = {
        ok: false,
        json: vi.fn().mockResolvedValue({
          error: { message: "Email already exists" },
        }),
      };

      global.fetch = vi.fn().mockResolvedValue(mockResponse);

      await expect(
        registerAction("John", "Doe", "existing@example.com", "password123"),
      ).rejects.toThrow("Email already exists");
    });

    it("should throw default error message if not provided", async () => {
      const mockResponse = {
        ok: false,
        json: vi.fn().mockResolvedValue({ error: {} }),
      };

      global.fetch = vi.fn().mockResolvedValue(mockResponse);

      await expect(
        registerAction("John", "Doe", "newuser@example.com", "password123"),
      ).rejects.toThrow("Registration failed");
    });
  });

  describe("getAccessTokenAction", () => {
    it("should return access token from cookies", async () => {
      mockCookieStore.get.mockReturnValue({ value: "access_token_123" });

      const result = await getAccessTokenAction();

      expect(result).toBe("access_token_123");
    });

    it("should return null if access token doesn't exist", async () => {
      mockCookieStore.get.mockReturnValue(undefined);

      const result = await getAccessTokenAction();

      expect(result).toBeNull();
    });
  });
});
