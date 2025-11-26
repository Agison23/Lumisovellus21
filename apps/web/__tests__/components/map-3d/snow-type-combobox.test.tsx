import { render, screen, fireEvent, cleanup } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect, vi, afterEach } from "vitest";
import { SnowTypeCombobox } from "../../../components/map-3d/snow-type-combobox";

// Mock the ResizeObserver which is used by some radix/cmdk components
global.ResizeObserver = class ResizeObserver {
  observe() {}
  unobserve() {}
  disconnect() {}
};

// Mock scrollIntoView
window.HTMLElement.prototype.scrollIntoView = vi.fn();

describe("SnowTypeCombobox", () => {
  const options = [
    { value: "type1", label: "Type 1" },
    { value: "type2", label: "Type 2" },
  ];

  afterEach(() => {
    cleanup();
  });

  it("should render with placeholder when no value selected", () => {
    render(
      <SnowTypeCombobox
        value={null}
        onChange={() => {}}
        options={options}
        placeholder="Select type"
      />,
    );
    expect(screen.getByRole("combobox")).toHaveTextContent("Select type");
  });

  it("should render selected label", () => {
    render(
      <SnowTypeCombobox value="type1" onChange={() => {}} options={options} />,
    );
    // Query by text content since button doesn't have accessible name
    expect(screen.getByText("Type 1")).toBeInTheDocument();
  });

  it("should call onChange when option selected", async () => {
    const onChange = vi.fn();
    const user = userEvent.setup();

    render(
      <SnowTypeCombobox
        value={null}
        onChange={onChange}
        options={options}
        placeholder="Select type"
      />,
    );

    // Open popover by clicking the button trigger
    const trigger = screen.getByText("Select type");
    await user.click(trigger);

    // Click option - use fireEvent because cmdk's onSelect expects the value prop
    const option = screen.getByRole("option", { name: "Type 2" });
    fireEvent.click(option);

    expect(onChange).toHaveBeenCalledWith("type2");
  });

  it("should deselect if same value clicked", async () => {
    const onChange = vi.fn();
    const user = userEvent.setup();

    render(
      <SnowTypeCombobox value="type1" onChange={onChange} options={options} />,
    );

    const trigger = screen.getByText("Type 1");
    await user.click(trigger);

    // Use fireEvent for CommandItem click
    fireEvent.click(screen.getByRole("option", { name: "Type 1" }));

    expect(onChange).toHaveBeenCalledWith(null);
  });
});
