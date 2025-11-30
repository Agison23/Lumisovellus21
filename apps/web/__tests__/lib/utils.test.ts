import { describe, it, expect } from "vitest";
import { getTranslationKeyForSnowTypeName, cn } from "../../lib/utils";

describe("utils", () => {
  describe("getTranslationKeyForSnowTypeName", () => {
    it("should return correct translation key for known snow types", () => {
      expect(getTranslationKeyForSnowTypeName("Korppu")).toBe("crust");
      expect(getTranslationKeyForSnowTypeName("Sohjo")).toBe("slush");
      expect(getTranslationKeyForSnowTypeName("Jää")).toBe("ice");
      expect(getTranslationKeyForSnowTypeName("Uusi lumi")).toBe("fresh");
    });

    it("should return correct translation key for all mapped snow types", () => {
      expect(getTranslationKeyForSnowTypeName("Tuulen pieksemä lumi")).toBe(
        "wind-blown",
      );
      expect(getTranslationKeyForSnowTypeName("Vähäinen lumi")).toBe("sparse");
      expect(getTranslationKeyForSnowTypeName("Lumeton maa")).toBe(
        "bare-ground",
      );
      expect(getTranslationKeyForSnowTypeName("Vitilumi")).toBe("powder-snow");
      expect(getTranslationKeyForSnowTypeName("Puuterilumi")).toBe("powder");
      expect(getTranslationKeyForSnowTypeName("Märkä uusi lumi")).toBe("wet");
      expect(getTranslationKeyForSnowTypeName("Sastrugi")).toBe("sastrugi");
      expect(getTranslationKeyForSnowTypeName("Aaltoileva lumi")).toBe("wavy");
      expect(getTranslationKeyForSnowTypeName("Tuiskulumi")).toBe(
        "wind-packed",
      );
      expect(getTranslationKeyForSnowTypeName("Ohut korppu")).toBe(
        "thin-crust",
      );
      expect(getTranslationKeyForSnowTypeName("Rikkoutuva korppu")).toBe(
        "breakable-crust",
      );
      expect(getTranslationKeyForSnowTypeName("Kantava korppu")).toBe(
        "bearing-crust",
      );
      expect(getTranslationKeyForSnowTypeName("Rikkoutuva jää")).toBe(
        "breakable-ice",
      );
      expect(getTranslationKeyForSnowTypeName("Kastuva lumi")).toBe(
        "softening-snow",
      );
      expect(getTranslationKeyForSnowTypeName("Saturoitunut lumi")).toBe(
        "saturated-snow",
      );
      expect(getTranslationKeyForSnowTypeName("Kiviä")).toBe("stones");
      expect(getTranslationKeyForSnowTypeName("Oksia")).toBe("branches");
    });

    it("should return lowercase hyphenated string for unknown types", () => {
      expect(getTranslationKeyForSnowTypeName("Unknown Type")).toBe(
        "unknown-type",
      );
      expect(getTranslationKeyForSnowTypeName("Test")).toBe("test");
    });

    it("should handle edge cases for unknown snow types", () => {
      // Note: replace only replaces first space, so multiple spaces stay as is
      expect(
        getTranslationKeyForSnowTypeName("Multiple Word Unknown Type"),
      ).toBe("multiple-word unknown type");
      expect(getTranslationKeyForSnowTypeName("Single")).toBe("single");
      expect(getTranslationKeyForSnowTypeName("UPPERCASE")).toBe("uppercase");
    });

    it("should be case-sensitive for known types", () => {
      // Known types are case-sensitive, so variations should be treated as unknown
      expect(getTranslationKeyForSnowTypeName("korppu")).toBe("korppu");
      expect(getTranslationKeyForSnowTypeName("KORPPU")).toBe("korppu");
      expect(getTranslationKeyForSnowTypeName("Uusi Lumi")).not.toBe("fresh");
    });

    it("should handle empty string", () => {
      const result = getTranslationKeyForSnowTypeName("");
      expect(result).toBe("");
    });

    it("should handle strings with extra spaces", () => {
      // Note: replace only replaces first space, so subsequent spaces remain
      expect(getTranslationKeyForSnowTypeName("Unknown  Type")).toBe(
        "unknown- type",
      );
    });
  });

  describe("cn", () => {
    it("should merge class names correctly", () => {
      expect(cn("c1", "c2")).toBe("c1 c2");
      expect(cn("c1", { c2: true, c3: false })).toBe("c1 c2");
    });

    it("should handle tailwind conflicts", () => {
      expect(cn("p-4", "p-2")).toBe("p-2");
      expect(cn("text-red-500", "text-blue-500")).toBe("text-blue-500");
    });
  });
});
