"use client";
import { DashboardSidebar } from "@/components/dashboard/sidebar";
import { SidebarProvider } from "@/components/ui/sidebar";
import { useTranslations } from "next-intl";
import { useState } from "react";

export default function DashboardLayout({
	children,
}: Readonly<{
	children: React.ReactNode;
}>) {
	const [mouseOverSidebar, setMouseOverSidebar] = useState(false);
	const handleMouseEnter = () => {
		setMouseOverSidebar(true);
	};
	const handleMouseLeave = () => {
		setMouseOverSidebar(false);
	};
	const t = useTranslations();
	return (
		<div className="relative w-full h-full">
			<SidebarProvider
				open={mouseOverSidebar}
				className="w-full h-full max-h-full min-h-full"
			>
				<div onMouseEnter={handleMouseEnter} onMouseLeave={handleMouseLeave}>
					<DashboardSidebar t={t} />
				</div>
				<div className="overflow-y-auto pb-12 w-full h-full">{children}</div>
			</SidebarProvider>
		</div>
	);
}
