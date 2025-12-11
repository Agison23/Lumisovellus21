import { describe, it, expect } from "vitest";
import { calculatePolygonArea } from "../../../lib/map/utils";

describe("lib/map/utils", () => {
  describe("calculatePolygonArea", () => {
    it("should calculate area of a simple square", () => {
      const square = [
        { lat: 0, lng: 0 },
        { lat: 1, lng: 0 },
        { lat: 1, lng: 1 },
        { lat: 0, lng: 1 },
      ];
      // Area of 1x1 square is 1
      expect(calculatePolygonArea(square)).toBeCloseTo(1);
    });

    it("should calculate area of a triangle", () => {
      const triangle = [
        { lat: 0, lng: 0 },
        { lat: 1, lng: 0 },
        { lat: 0, lng: 1 },
      ];
      // Area of triangle with base 1 and height 1 is 0.5
      expect(calculatePolygonArea(triangle)).toBeCloseTo(0.5);
    });

    it("should return 0 for empty points", () => {
      expect(calculatePolygonArea([])).toBe(0);
    });

    it("should return 0 for single point", () => {
      expect(calculatePolygonArea([{ lat: 0, lng: 0 }])).toBe(0);
    });
  });
});
