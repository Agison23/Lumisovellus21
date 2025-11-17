"use client";

import {Cloudy, Info, LayoutDashboard, Map} from "lucide-react";
import Link from "next/link";
import {usePathname} from "next/navigation";
import {useTranslations} from "next-intl";
import {NavigationMenu, NavigationMenuItem, NavigationMenuLink, NavigationMenuList,} from "./ui/navigation-menu";
import {useAuth} from "@/hooks/use-auth";
import * as routes from "@/lib/routes";

export default function Nav() {
  const tApp = useTranslations("AppLayout");
  const path = usePathname();
  const {isLoggedIn} = useAuth();

  const isCurrentPath = (routePath: string) => {
    if (routePath === "/") {
      // Only highlight Map if we're exactly on the root
      return path === "/";
    }
    // For other routes, check if the current path starts with the route path (with trailing slash normalization)
    const normalizePath = (p: string) => (p.endsWith("/") ? p : p + "/");
    return normalizePath(path).startsWith(normalizePath(routePath));
  };

  const visibleRoutes = routes.routeDefinitions.filter(route => {
    if (route.name.toLowerCase() === "dashboard") {
      return isLoggedIn;
    }
    return true;
  })

  return (
    <NavigationMenu>
      <NavigationMenuList className="bg-background rounded-md p-1 pointer-events-auto border border-accent shadow-md">
        {visibleRoutes.map((route) => (
          <NavigationMenuItem
            key={route.path}
            className={
              isCurrentPath(route.path) ? "underline underline-offset-4" : ""
            }
          >
            <NavigationMenuLink asChild>
              <Link href={route.path}>
                <div className="flex gap-2 items-center">
                  <NavigationItemIcon {...route} />
                  {tApp(route.i18nKey)}
                </div>
              </Link>
            </NavigationMenuLink>
          </NavigationMenuItem>
        ))}
      </NavigationMenuList>
    </NavigationMenu>
  );
}

function NavigationItemIcon(route: routes.RouteDefinition): React.ReactNode {
  switch (route.name.toLowerCase()) {
    case "map":
      return <Map/>;
    case "definitions":
      return <Info/>;
    case "weather":
      return <Cloudy/>;
    case "dashboard":
      return <LayoutDashboard/>;
    default:
      return <></>;
  }
}
