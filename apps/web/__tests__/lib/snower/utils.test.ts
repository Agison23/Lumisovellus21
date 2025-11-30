import { describe, it, expect } from "vitest";
import { Monitor } from "../../../lib/snower/types";
import {
  formatValueToString,
  formatValueToObject,
  mergeMonitors,
  isWithinBounds,
} from "../../../lib/snower/utils";

describe("lib/snower/utils", () => {
  describe("formatValueToString", () => {
    it("should format number with unit", () => {
      expect(formatValueToString(10.123, "C")).toBe("10.12 C");
    });

    it("should format number without unit", () => {
      expect(formatValueToString(10.123)).toBe("10.12");
    });

    it("should handle null/undefined/empty", () => {
      expect(formatValueToString(null)).toBe("Not available");
      expect(formatValueToString(undefined)).toBe("Not available");
      expect(formatValueToString("")).toBe("Not available");
    });

    it("should handle non-numeric strings", () => {
      expect(formatValueToString("abc")).toBe("Not available");
    });
  });

  describe("formatValueToObject", () => {
    it("should format number with unit", () => {
      expect(formatValueToObject(10.123, "C")).toEqual({
        value: 10.123,
        unit: "C",
      });
    });

    it("should handle null/undefined", () => {
      expect(formatValueToObject(null)).toBe("No Data");
      expect(formatValueToObject(undefined)).toBe("No Data");
    });
  });

  describe("mergeMonitors", () => {
    it("should merge fetched data into defaults", () => {
      const defaults: Monitor[] = [{ name: "M1", lat: 0, lng: 0 }] as Monitor[];
      const fetched: Monitor[] = [
        { name: "M1", temperature: { value: 10, unit: "C" } },
      ] as Monitor[];

      const merged = mergeMonitors(defaults, fetched);
      expect(merged).toHaveLength(1);
      expect(merged[0].temperature).toEqual({ value: 10, unit: "C" });
    });

    it("should add new monitors from fetched", () => {
      const defaults: Monitor[] = [];
      const fetched: Monitor[] = [{ name: "M1", lat: 0, lng: 0 }] as Monitor[];

      const merged = mergeMonitors(defaults, fetched);
      expect(merged).toHaveLength(1);
      expect(merged[0].name).toBe("M1");
    });
  });

  describe("isWithinBounds", () => {
    const bounds: [[number, number], [number, number]] = [
      [0, 0],
      [10, 10],
    ]; // [minLng, minLat], [maxLng, maxLat]

    it("should return true if inside bounds", () => {
      expect(isWithinBounds(5, 5, bounds)).toBe(true);
    });

    it("should return false if outside bounds", () => {
      expect(isWithinBounds(11, 5, bounds)).toBe(false); // lat too high (assuming lat is 2nd arg in bounds? wait, let's check impl)
      // impl: lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng
      // bounds[0] is [minLng, minLat], bounds[1] is [maxLng, maxLat]
      // isWithinBounds(lat, lng, bounds)

      expect(isWithinBounds(11, 5, bounds)).toBe(false); // lat 11 > maxLat 10
      expect(isWithinBounds(5, 11, bounds)).toBe(false); // lng 11 > maxLng 10
    });
  });
});
