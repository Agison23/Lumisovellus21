// Add this at the top with other imports/helpers

const CAMERA_STATE_KEY = "map3d_camera_state";

export interface CameraState {
	longitude: number;
	latitude: number;
	zoom: number;
	pitch: number;
	bearing: number;
}

export const saveCameraState = (state: CameraState) => {
	if (typeof window === "undefined" || !window.localStorage) return;
	try {
		localStorage.setItem(CAMERA_STATE_KEY, JSON.stringify(state));
	} catch (error) {
		console.error("Failed to save camera state:", error);
	}
};

export const loadCameraState = (): CameraState | null => {
	if (typeof window === "undefined" || !window.localStorage) return null;
	try {
		const stored = localStorage.getItem(CAMERA_STATE_KEY);
		return stored ? JSON.parse(stored) : null;
	} catch (error) {
		console.error("Failed to load camera state:", error);
		return null;
	}
};

export const DEFAULT_VIEW_STATE: CameraState = {
	longitude: 24.05,
	latitude: 68.05,
	zoom: 13,
	pitch: 60,
	bearing: 0,
};
