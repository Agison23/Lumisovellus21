"use client";
import { DashboardSidebar } from "@/components/dashboard/sidebar";
import { SidebarProvider } from "@/components/ui/sidebar";
import { useTranslations } from "next-intl";
import Link from "next/link";
import { usePathname } from "next/navigation";
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

	const path = usePathname();

	type PathElement = {
		name: string;
		path: string;
	};

	const createPathElements = (path: string): PathElement[] => {
		// creates an array of path elements from the current path
		// for example, /dashboard/reports -> [{name: 'dashboard', path: '/dashboard'}, {name: 'reports', path: '/dashboard/reports'}]
		const segments = path.split("/").filter(Boolean);
		const pathElements: PathElement[] = [];
		let currentPath = "";
		segments.forEach((segment) => {
			currentPath += `/${segment}`;
			pathElements.push({ name: segment, path: currentPath });
		});

		// if length is 1, i.e., only /dashboard add /overview
		if (pathElements.length === 1) {
			pathElements.push({
				name: "overview",
				path: `${pathElements[0].path}/overview`,
			});
		}
		return pathElements;
	};

	return (
		<div className="relative w-full h-full">
			<SidebarProvider
				open={mouseOverSidebar}
				className="w-full h-full max-h-full min-h-full"
			>
				<div onMouseEnter={handleMouseEnter} onMouseLeave={handleMouseLeave}>
					<DashboardSidebar t={t} />
				</div>
				<div className="overflow-hidden w-full h-full flex flex-col">
					<nav className="text-sm p-2 flex gap-2">
						<ul className="flex gap-2">
							{createPathElements(path).map((element, index) => (
								<div key={element.path} className="flex gap-2">
									<Link
										href={element.path}
										key={element.path}
										className="capitalize"
									>
										{element.path === "/dashboard"
											? t("Dashboard.title")
											: t(
													`Dashboard.${element.name.charAt(0).toUpperCase() + element.name.slice(1)}Page.title`
												)}
									</Link>
									{index < createPathElements(path).length - 1 && (
										<span>/</span>
									)}
								</div>
							))}
						</ul>
					</nav>
					<div className="flex flex-col overflow-y-auto w-full h-full pb-14">
						{children}
					</div>
				</div>
			</SidebarProvider>
		</div>
	);
}
