type MapLoadingOverlayProps = {
	showLoading: boolean;
	isLoading: boolean;
	loadingText?: string;
};

export default function MapLoadingOverlay({
	showLoading,
	isLoading,
	loadingText,
}: MapLoadingOverlayProps) {
	if (!showLoading) {
		return null;
	}

	return (
		<div
			className={`absolute inset-0 z-50 flex items-center justify-center bg-background backdrop-blur-sm transition-opacity duration-500 ${
				isLoading ? "opacity-100" : "opacity-0"
			}`}
		>
			<div className="flex flex-col items-center gap-4">
				<p className="text-primary text-lg font-medium animate-pulse">
					{loadingText}
				</p>
			</div>
		</div>
	);
}
