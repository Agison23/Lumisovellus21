export const CONTROL_STORAGE_KEYS = {
	SHOW_AREAS: "map-controls-show-areas",
	SHOW_MONITORS: "map-controls-show-monitors",
} as const;

export const loadControlState = (
	key: string,
	defaultValue: boolean
): boolean => {
	const stored = localStorage.getItem(key);
	return stored !== null ? JSON.parse(stored) : defaultValue;
};

export const saveControlState = (key: string, value: boolean): void => {
	localStorage.setItem(key, JSON.stringify(value));
};
