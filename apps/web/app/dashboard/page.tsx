"use client";
import { paths } from "@lumisovellus/api-client-web";
import { useTranslations } from "next-intl";
import { useAuth } from "@/hooks/use-auth";

type Users =
  paths["/api/v1/users"]["get"]["responses"]["200"]["content"]["application/json"]["data"];

export default function DashboardPage() {
  const t = useTranslations("Dashboard.OverviewPage");
  const { user } = useAuth();

  if (!user) return null;

  const getUserGreeting = () => {
    // get hours in 24h format, now matter the local style (NO PM/AM)
    const hour = new Date().getHours();
    // morning, day, afternoon, evening, night
    if (hour < 6) return t("greetings.night", { name: user.firstName });
    if (hour < 11) return t("greetings.morning", { name: user.firstName });
    if (hour < 14) return t("greetings.day", { name: user.firstName });
    if (hour < 18) return t("greetings.afternoon", { name: user.firstName });
    if (hour < 22) return t("greetings.evening", { name: user.firstName });
    return t("greetings.night", { name: user.firstName });
  };

  return (
    <div className="p-2 gap-2">
      <div className="flex items-center gap-2">
        <h1 className="text-xl">{getUserGreeting()}!</h1>
      </div>
      <p>
        {user.firstName} {user.lastName}
      </p>
      <p>{t("user.email")}: {user.email}</p>
      <p>{t("user.role")}: {user.role}</p>
      <p>{t("user.id")}: {user.id}</p>
    </div>
  );
}
