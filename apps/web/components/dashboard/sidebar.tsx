"use client";
import { Clipboard, House, LandPlot, Users } from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  Sidebar,
  SidebarContent,
  SidebarGroup,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from "../ui/sidebar";
import { useAuth } from "@/hooks/use-auth";
type SidebarLink = {
  href: string;
  label: string;
  icon?: React.ReactNode;
  allowedRoles: string[];
};
const sidebarLinks: SidebarLink[] = [
  {
    href: "/dashboard",
    label: "Dashboard.OverviewPage.title",
    icon: <House />,
    allowedRoles: ["ADMIN", "GUIDE", "NORMAL", "RESCUE"],
  },
  {
    href: "/dashboard/reports",
    label: "Dashboard.ReportsPage.title",
    icon: <Clipboard />,
    allowedRoles: ["ADMIN", "GUIDE", "RESCUE"],
  },
  {
    href: "/dashboard/users",
    label: "Dashboard.UsersPage.title",
    icon: <Users />,
    allowedRoles: ["ADMIN"],
  },
  {
    href: "/dashboard/segments",
    label: "Dashboard.SegmentsPage.title",
    icon: <LandPlot />,
    allowedRoles: ["ADMIN", "GUIDE", "RESCUE"],
  },
];

export function DashboardSidebar({
  t,
}: {
  t: (key: string, params?: Record<string, string>) => string;
}) {
  const path = usePathname();
  const userRole = useAuth().user?.role;

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
              {sidebarLinks.map(
                (link) =>
                  userRole &&
                  link.allowedRoles.includes(userRole) && (
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
                  ),
              )}
            </SidebarMenu>
          </SidebarContent>
        </SidebarGroup>
      </SidebarContent>
    </Sidebar>
  );
}
