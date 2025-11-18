"use client";
import { useAuth } from "@/hooks/use-auth";
import { useTranslations } from "next-intl";

export default function DashboardPage() {
  const t = useTranslations("Dashboard.OverviewPage");
  const { user } = useAuth();

  return (
    <div className="p-2">
      <h1>{t("title")}</h1>
      <p>hello!</p>
      <p>
        {user?.firstName} {user?.lastName}
      </p>
      <p>email: {user?.email}</p>
      <p>Role: {user?.role}</p>
      <p>Id: {user?.id}</p>
    </div>
  );
}
