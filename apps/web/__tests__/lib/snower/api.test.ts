import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { API_ENDPOINTS } from "../../../lib/snower/constants";
import { SnowerAPI } from "../../../lib/snower/index";

describe("lib/snower/index", () => {
  const mockFetch = vi.fn();

  beforeEach(() => {
    vi.stubGlobal("fetch", mockFetch);
    // Mock environment variables required by SnowerAPI
    vi.stubEnv("SNOWER_API_KEY", "test-api-key");
    vi.stubEnv("SNOWER_USERNAME", "test-username");
    vi.stubEnv("SNOWER_PASSWORD", "test-password");
  });

  afterEach(() => {
    vi.unstubAllGlobals();
    vi.clearAllMocks();
  });

  describe("SnowerAPI", () => {
    it("should authenticate and set auth key", async () => {
      const api = new SnowerAPI();

      mockFetch.mockResolvedValueOnce({
        ok: true,
        json: async () => ({ authentication_key: "new-key" }),
      });

      await api.authenticate();

      expect(mockFetch).toHaveBeenCalledWith(
        API_ENDPOINTS.login,
        expect.objectContaining({
          method: "POST",
          body: JSON.stringify({
            username: "test-username",
            password: "test-password",
          }),
        }),
      );

      // We can't easily check private authKey, but we can verify subsequent calls use it
      // or we could check if it didn't throw
    });

    it("should fetch monitor list", async () => {
      const api = new SnowerAPI();
      const monitors = ["M1", "M2"];

      mockFetch.mockResolvedValueOnce({
        ok: true,
        json: async () => monitors,
      });

      const result = await api.getMonitorList();
      expect(result).toEqual(monitors);
      expect(mockFetch).toHaveBeenCalledWith(
        API_ENDPOINTS.monitorsList,
        expect.anything(),
      );
    });

    it("should handle fetch errors gracefully", async () => {
      const api = new SnowerAPI();
      const consoleErrorSpy = vi
        .spyOn(console, "error")
        .mockImplementation(() => {});

      mockFetch.mockRejectedValueOnce(new Error("Network error"));

      // Should return default monitors on error (based on implementation)
      const result = await api.getMonitorList();
      expect(Array.isArray(result)).toBe(true);
      expect(result.length).toBeGreaterThan(0); // Should have defaults

      consoleErrorSpy.mockRestore();
    });
  });
});
