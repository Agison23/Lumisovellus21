import { describe, it, expect, beforeEach, vi } from "vitest";
import { render, screen, waitFor } from "@testing-library/react";
import WeatherView from "../components/weather/weather-view";

// ----- Translation mock -----
// We preserve key ("windDirection") and include interpolated values ("250")
vi.mock("next-intl", () => ({
  useTranslations: () => (key: string, vars?: any) => {
    const label = key.split(".").at(-1); // e.g., "windDirection"
    if (vars) return `${label} ${Object.values(vars).join(" ")}`;
    return label;
  },
}));

// ----- Helper: mock sequential fetch responses -----
function mockFetchSequence(responses: any[]) {
  vi.stubGlobal(
    "fetch",
    vi.fn().mockImplementation(() => {
      const next = responses.shift();
      return Promise.resolve({
        json: () => Promise.resolve(next),
      });
    })
  );
}

describe("WeatherView", () => {
  beforeEach(() => {
    vi.restoreAllMocks();
  });

  // --------------------------------------------------------------------
  // POSITIVE CASE
  // --------------------------------------------------------------------
  it("renders weather data when API responses are successful", async () => {
    mockFetchSequence([
      { success: true, data: { value: 5 } },   // avg wind speed
      { success: true, data: { value: 250 } }, // avg wind direction
      { success: true, data: { value: -10 } }, // min temp
      { success: true, data: { value: -2 } },  // max temp
      { success: true, data: { value: 12 } },  // max wind speed
      { success: true, data: { value: 3 } },   // snow depth change
      {
        success: true,
        data: { matches: [{ date: "2025-11-29", averageTemperature: 1.2 }] },
      },
    ]);

    render(<WeatherView />);

    expect(screen.getByText("loading")).toBeInTheDocument();

    await waitFor(() => {
      expect(screen.getByText("5 m/s")).toBeInTheDocument();
      expect(screen.getByText("windDirection 250")).toBeInTheDocument();
      expect(screen.getByText("-10 °C")).toBeInTheDocument();
      expect(screen.getByText("-2 °C")).toBeInTheDocument();
      expect(screen.getByText("12 m/s")).toBeInTheDocument();
      expect(screen.getByText("+3 cm")).toBeInTheDocument();
      expect(screen.getByText(/2025-11-29/)).toBeInTheDocument();
    });
  });

  // --------------------------------------------------------------------
  // NEGATIVE CASE: missing values
  // --------------------------------------------------------------------
  it("renders 'notAvailable' when API returns missing values", async () => {
    mockFetchSequence([
      { success: false },
      { success: true, data: { value: null } },
      { success: true, data: null },
      { success: true, data: { value: undefined } },
      { success: false },
      { success: false },
      { success: true, data: { matches: [] } },
    ]);

    render(<WeatherView />);

    await waitFor(() => {
      // match trimming whitespace
      const notAvailElems = screen.getAllByText((t) =>
        t.trim() === "notAvailable"
      );
      expect(notAvailElems.length).toBeGreaterThan(3);

      expect(screen.getByText("noAboveFreezing")).toBeInTheDocument();
    });
  });

  // --------------------------------------------------------------------
  // NEGATIVE CASE: network failure
  // --------------------------------------------------------------------
  it("handles network failures gracefully", async () => {
    vi.stubGlobal("fetch", vi.fn().mockRejectedValue(new Error("Network fail")));

    render(<WeatherView />);

    expect(screen.getByText("loading")).toBeInTheDocument();

    await waitFor(() => {
        expect(screen.getByText("loading")).toBeInTheDocument();
    });
  });
});
