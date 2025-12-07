import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect, vi } from "vitest";
import MonitorInfo from "../../../components/map-3d/monitor-info";
import { Monitor } from "../../../lib/snower/types";

describe("MonitorInfo", () => {
  const mockMonitor: Monitor = {
    name: "Test Monitor",
    lat: 60,
    lng: 24,
    temperature: { value: -5, unit: "C" },
    temperatureString: "-5.00 C",
    snowDepth: { value: 50, unit: "cm" },
    snowDepthString: "50.00 cm",
  };

  const mockT = vi.fn((key) => key);

  it("should render monitor details", () => {
    render(<MonitorInfo monitor={mockMonitor} onClose={() => {}} t={mockT} />);

    expect(screen.getByText("Test Monitor")).toBeInTheDocument();
    expect(screen.getByText("-5.00 C")).toBeInTheDocument();
    expect(screen.getByText("50.00 cm")).toBeInTheDocument();
    expect(screen.getByText(/60.0000/)).toBeInTheDocument();
    expect(screen.getByText(/24.0000/)).toBeInTheDocument();
  });

  it("should handle missing data", () => {
    const noDataMonitor: Monitor = {
      ...mockMonitor,
      temperature: "No Data",
      snowDepth: "No Data",
    };

    render(
      <MonitorInfo monitor={noDataMonitor} onClose={() => {}} t={mockT} />,
    );

    expect(mockT).toHaveBeenCalledWith("monitorInfo.fields.temperature.noData");
    expect(mockT).toHaveBeenCalledWith("monitorInfo.fields.snowDepth.noData");
  });

  it("should call onClose when close button clicked", async () => {
    const onClose = vi.fn();
    const user = userEvent.setup();

    render(<MonitorInfo monitor={mockMonitor} onClose={onClose} t={mockT} />);

    const closeButton = screen.getByRole("button");
    await user.click(closeButton);
    expect(onClose).toHaveBeenCalled();
  });
});
