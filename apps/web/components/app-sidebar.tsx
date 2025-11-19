'use client';
import { useTranslations } from 'next-intl';
import { useRouter } from 'next/navigation';
import LocaleSwitcher from './locale-switcher';
import { ThemeToggle } from './theme/theme-toggle';
import {
  Sidebar,
  SidebarContent,
  SidebarGroup,
  SidebarGroupContent,
  SidebarHeader,
  SidebarTrigger,
} from './ui/sidebar';
import { useAuth } from '@/hooks/use-auth';
import { Button } from './ui/button';
import { LogIn, LogInIcon, LogOut, LogOutIcon } from 'lucide-react';
import Link from 'next/link';
import { logoutAction } from '@/app/(auth)/actions';

export default function AppSidebar() {
  const t = useTranslations('Sidebar');
  const router = useRouter();
  const isLoggedIn = useAuth().isLoggedIn;

  const handleLogout = async () => {
    await logoutAction();
    router.refresh();
    router.push('/');
  };

  return (
    <Sidebar
      side="left"
      variant="inset"
    >
      <SidebarHeader>
        <div className="flex gap-2 items-center text-xs w-full flex-wrap">
          <LocaleSwitcher />
          <ThemeToggle />
          {isLoggedIn ? (
            <Button
              variant="outline"
              size="sm"
              className="w-max px-2"
              aria-label={t('logIn.logOut')}
              onClick={handleLogout}
            >
              <LogOutIcon className="size-4" />
            </Button>
          ) : (
            <Link href="/login">
              <Button
                variant="outline"
                size="sm"
                className="w-max px-2"
                aria-label={t('logIn.logIn')}
              >
                <LogInIcon className="size-4" />
              </Button>
            </Link>
          )}
          <div className="w-full md:hidden flex justify-start items-center z-999 p-2">
            <SidebarTrigger className="bg-background" />
          </div>
        </div>

        <h1>{t('title')}</h1>
      </SidebarHeader>
      <SidebarContent>
        <SidebarGroup>
          <SidebarGroupContent>
            <div className="flex flex-col gap-4">
              <p>{t('p1')}</p>
              <p>{t('p2')}</p>
              <p>{t('p3')}</p>
              <p>{t('p4')}</p>
            </div>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>
    </Sidebar>
  );
}
