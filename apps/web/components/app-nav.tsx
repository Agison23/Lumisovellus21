'use client'

import { Cloudy, Info, Map } from 'lucide-react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useTranslations } from 'next-intl';
import { NavigationMenu, NavigationMenuItem, NavigationMenuList, NavigationMenuLink } from './ui/navigation-menu';
import * as routes from '@/lib/routes';

export default function Nav() {
  const tApp = useTranslations('AppLayout');
  const path = usePathname();

  return (
      <NavigationMenu>
        <NavigationMenuList>
          {routes.routeDefinitions.map((route) => (
            <NavigationMenuItem key={route.path} className={path === route.path ? 'underline underline-offset-4' : ''}>
              <NavigationMenuLink asChild>
                <Link href={route.path}>
                  <div className='flex gap-2 items-center'>
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
    case 'map':
      return <Map />;
    case 'definitions':
      return <Info />;
    case 'weather':
      return <Cloudy />;
    default:
        return <></>;
  }
}
