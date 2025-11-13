import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { Monitor } from "@/lib/snower/types";
type MonitorInfoProps = {
	monitor: Monitor;
	onClose: () => void;
	t: (key: string, params?: Record<string, string>) => string;
};

export default function MonitorInfo({ monitor, onClose, t }: MonitorInfoProps) {
	return (
		<div className="absolute top-12 left-2 bg-background p-2 rounded-lg shadow-lg text-sm flex flex-col gap-2 animate-in fade-in zoom-in-95 duration-200 w-80 max-w-[90vw]">
			<div className="flex flex-col gap-2">
				<h3 className="font-medium text-base">{monitor.name}</h3>
				<Separator />
				<div className="flex flex-col gap-3">
					<div>
						<p className="text-muted-foreground text-xs">
							{t("monitorInfo.fields.temperature.label")}
						</p>
						<p className="font-medium">
							{monitor.temperature === "No Data"
								? t("monitorInfo.fields.temperature.noData")
								: monitor.temperatureString}
						</p>
					</div>
					<div>
						<p className="text-muted-foreground text-xs">
							{t("monitorInfo.fields.snowDepth.label")}
						</p>
						<p className="font-medium">
							{monitor.snowDepth === "No Data"
								? t("monitorInfo.fields.snowDepth.noData")
								: monitor.snowDepthString}
						</p>
					</div>
					<div className="text-xs text-muted-foreground">
						<p>
							{t("monitorInfo.fields.coordinates.latitude")}:{" "}
							{monitor.lat.toFixed(4)}
						</p>
						<p>
							{t("monitorInfo.fields.coordinates.longitude")}:{" "}
							{monitor.lng.toFixed(4)}
						</p>
					</div>
				</div>
			</div>
			<Button variant="default" onClick={onClose} className="w-full">
				{t("reportForm.buttons.close")}
			</Button>
		</div>
	);
}
