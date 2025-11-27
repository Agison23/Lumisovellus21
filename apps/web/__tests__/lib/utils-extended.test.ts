import { describe, it, expect } from "vitest";
import { getSnowTypeNameById } from "../../lib/utils";

describe("utils - extended", () => {
  describe("getSnowTypeNameById", () => {
    const mockSnowTypes = [
      { id: "1", name: "Korppu" },
      { id: "2", name: "Sohjo" },
      { id: "3", name: "Jää" },
      { id: "4", name: "Uusi lumi" },
      { id: "5", name: "Tuulen pieksemä lumi" },
    ];

    it("should return snow type name for valid ID", () => {
      expect(getSnowTypeNameById(mockSnowTypes, "1")).toBe("Korppu");
      expect(getSnowTypeNameById(mockSnowTypes, "2")).toBe("Sohjo");
      expect(getSnowTypeNameById(mockSnowTypes, "5")).toBe(
        "Tuulen pieksemä lumi",
      );
    });

    it("should return empty string for invalid ID", () => {
      expect(getSnowTypeNameById(mockSnowTypes, "999")).toBe("");
      expect(getSnowTypeNameById(mockSnowTypes, "invalid")).toBe("");
    });

    it("should handle empty array", () => {
      expect(getSnowTypeNameById([], "1")).toBe("");
    });

    it("should handle numeric string IDs", () => {
      expect(getSnowTypeNameById(mockSnowTypes, "3")).toBe("Jää");
    });

    it("should be case-sensitive for ID matching", () => {
      expect(getSnowTypeNameById(mockSnowTypes, "1")).toBe("Korppu");
      expect(getSnowTypeNameById(mockSnowTypes, "ID1")).toBe("");
    });

    it("should handle array with duplicate IDs (returns first match)", () => {
      const snowTypesWithDuplicates = [
        { id: "1", name: "First" },
        { id: "1", name: "Second" },
      ];
      expect(getSnowTypeNameById(snowTypesWithDuplicates, "1")).toBe("First");
    });

    it("should handle snow types with special characters in names", () => {
      const specialSnowTypes = [
        { id: "1", name: "Lumi-kivi" },
        { id: "2", name: "Lumi (härkkä)" },
      ];
      expect(getSnowTypeNameById(specialSnowTypes, "1")).toBe("Lumi-kivi");
      expect(getSnowTypeNameById(specialSnowTypes, "2")).toBe("Lumi (härkkä)");
    });
  });
});
