
import { useTranslations } from "next-intl";
import LocaleSwitcher from "./locale-switcher";
import { Sidebar, SidebarContent, SidebarGroup, SidebarHeader, SidebarGroupContent } from "./ui/sidebar";
import { ThemeToggle } from "./theme/theme-toggle";

export default function AppSidebar() {
  const t = useTranslations("Sidebar");
  return (
    <Sidebar side="left" variant="inset">
      <SidebarHeader>
        <div className="flex gap-2">
            <LocaleSwitcher />
            <ThemeToggle />
        </div>

        <h1>{t('title')}</h1>
      </SidebarHeader>
      <SidebarContent>
        <SidebarGroup>
          <SidebarGroupContent>
            <div className="flex flex-col gap-4">
          <p>
            {t('p1')}
          </p>
          <p>
            {t('p2')}
          </p>
          <p>
            {t('p3')}
          </p>
          <p>
            {t('p4')}
          </p>
            </div>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>
    </Sidebar>
  )
}
