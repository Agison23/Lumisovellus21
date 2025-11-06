"use client";
import { usePathname } from "next/navigation";
import {
	Sidebar,
	SidebarContent,
	SidebarGroup,
	SidebarGroupLabel,
	SidebarHeader,
	SidebarMenu,
	SidebarMenuButton,
	SidebarMenuItem,
	SidebarTrigger,
} from "../ui/sidebar";
import Link from "next/link";
import { Clipboard, House, LandPlot, Users } from "lucide-react";
import { useState } from "react";
type SidebarLink = {
	href: string;
	label: string;
	icon?: React.ReactNode;
};
const sidebarLinks: SidebarLink[] = [
	{
		href: "/dashboard",
		label: "Dashboard.OverviewPage.title",
		icon: <House />,
	},
	{
		href: "/dashboard/reports",
		label: "Dashboard.ReportsPage.title",
		icon: <Clipboard />,
	},
	{
		href: "/dashboard/users",
		label: "Dashboard.UsersPage.title",
		icon: <Users />,
	},
	{
		href: "/dashboard/segments",
		label: "Dashboard.SegmentsPage.title",
		icon: <LandPlot />,
	},
];

export function DashboardSidebar({
	t,
}: {
	t: (key: string, params?: Record<string, string>) => string;
}) {
	const path = usePathname();

	return (
		<Sidebar
			variant="sidebar"
			side="right"
			className="relative z-0"
			collapsible="icon"
		>
			<SidebarContent className="pt-8">
				<SidebarGroup>
					<SidebarContent>
						<SidebarMenu>
							{sidebarLinks.map((link) => (
								<Link href={link.href} key={link.href}>
									<SidebarMenuItem
										className={`${path === link.href ? "bg-accent border rounded-md" : "border border-transparent"} cursor-pointer`}
										key={link.href}
									>
										<SidebarMenuButton className="cursor-pointer">
											{link.icon} {t(link.label)}
										</SidebarMenuButton>
									</SidebarMenuItem>
								</Link>
							))}
						</SidebarMenu>
					</SidebarContent>
				</SidebarGroup>
			</SidebarContent>
		</Sidebar>
	);
}
