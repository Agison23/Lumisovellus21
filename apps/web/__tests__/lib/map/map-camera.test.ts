import { describe, it, expect, beforeEach, vi, afterEach } from "vitest";
import {
  saveCameraState,
  loadCameraState,
  DEFAULT_VIEW_STATE,
  CameraState,
} from "../../../lib/map/map-camera";

describe("lib/map/map-camera", () => {
  const mockLocalStorage = (() => {
    let store: Record<string, string> = {};
    return {
      getItem: vi.fn((key: string) => store[key] || null),
      setItem: vi.fn((key: string, value: string) => {
        store[key] = value.toString();
      }),
      clear: () => {
        store = {};
      },
    };
  })();

  beforeEach(() => {
    vi.stubGlobal("localStorage", mockLocalStorage);
    mockLocalStorage.clear();
  });

  afterEach(() => {
    vi.unstubAllGlobals();
  });

  describe("saveCameraState", () => {
    it("should save state to localStorage", () => {
      const state: CameraState = {
        longitude: 10,
        latitude: 20,
        zoom: 5,
        pitch: 45,
        bearing: 90,
      };
      saveCameraState(state);
      expect(localStorage.setItem).toHaveBeenCalledWith(
        "map3d_camera_state",
        JSON.stringify(state),
      );
    });

    it("should handle errors gracefully", () => {
      vi.spyOn(console, "error").mockImplementation(() => {});
      const error = new Error("Storage full");
      mockLocalStorage.setItem.mockImplementationOnce(() => {
        throw error;
      });

      const state = { ...DEFAULT_VIEW_STATE };
      saveCameraState(state);

      expect(console.error).toHaveBeenCalledWith(
        "Failed to save camera state:",
        error,
      );
    });
  });

  describe("loadCameraState", () => {
    it("should return null if no state saved", () => {
      expect(loadCameraState()).toBeNull();
    });

    it("should return parsed state if saved", () => {
      const state: CameraState = {
        longitude: 10,
        latitude: 20,
        zoom: 5,
        pitch: 45,
        bearing: 90,
      };
      mockLocalStorage.setItem("map3d_camera_state", JSON.stringify(state));

      const loaded = loadCameraState();
      expect(loaded).toEqual(state);
    });

    it("should handle invalid JSON", () => {
      vi.spyOn(console, "error").mockImplementation(() => {});
      mockLocalStorage.setItem("map3d_camera_state", "invalid json");

      expect(loadCameraState()).toBeNull();
      expect(console.error).toHaveBeenCalled();
    });
  });
});
