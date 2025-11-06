import { useTranslations } from "next-intl";

export default function DashboardPage() {
	const t = useTranslations("Dashboard.OverviewPage");

	return (
		<div className="p-2">
			<h1>{t("title")}</h1>
		</div>
	);
}
