"use client";
import { getAccessTokenAction } from "@/app/(auth)/actions";
import { Input } from "@/components/ui/input";
import { apiUrl } from "@/lib/map/loaders";
import { paths } from "@lumisovellus/api-client-web";
import { useQuery } from "@tanstack/react-query";
import { useTranslations } from "next-intl";
import { ChangeEvent, useMemo, useState } from "react";

export default function DashboardPage() {
  const t = useTranslations("Dashboard.UsersPage");

  type Users =
    paths["/api/v1/users"]["get"]["responses"]["200"]["content"]["application/json"]["data"];

  const {
    data: users = [],
    isLoading,
    isError,
    refetch,
  } = useQuery({
    queryKey: ["users"],
    queryFn: async () => {
      const accessToken = await getAccessTokenAction();
      type UsersResponse =
        paths["/api/v1/users"]["get"]["responses"]["200"]["content"]["application/json"];
      if (!accessToken) {
        throw new Error("User is not authenticated");
      }
      const response = await fetch(`${apiUrl}/api/v1/users`, {
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
      });
      if (!response.ok) {
        throw new Error("Failed to fetch users");
      }
      const data: UsersResponse = await response.json();
      return data.data;
    },
    staleTime: 5 * 60 * 1000,
  });

  const [searchTerm, setSearchTerm] = useState("");

  const filteredUsers = useMemo(() => {
    if (searchTerm.trim() === "") {
      return users;
    }

    const tokens = searchTerm.toLowerCase().split(" ").filter(Boolean);

    return users.filter((user) =>
      tokens.every(
        (token) =>
          user.firstName.toLowerCase().includes(token) ||
          user.lastName?.toLowerCase().includes(token) ||
          user.email?.toLowerCase().includes(token) ||
          user.role.toLowerCase().includes(token) ||
          user.id.toLowerCase().includes(token),
      ),
    );
  }, [users, searchTerm]);

  return (
    <div className="p-2 flex flex-col gap-2 w-full overflow-hidden">
      {isLoading && <p>{t("loading")}</p>}
      {isError && <p>{t("errors.loadingFailed")}</p>}
      {!isLoading && !isError && (
        <>
          <Input
            onChange={(e: ChangeEvent<HTMLInputElement>) =>
              setSearchTerm(e.currentTarget.value)
            }
            value={searchTerm}
            placeholder={t("search.placeholder")}
            className="h-max"
          />
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-2 overflow-y-auto pb-14">
            {filteredUsers.map((user) => (
              <div
                key={user.id}
                className="border rounded-md text-left p-2 items-start flex flex-col gap-2 bg-background"
              >
                <div className="flex gap-2 justify-between items-center w-full">
                  <p className="font-bold">
                    {user.firstName} {user.lastName}
                  </p>
                </div>
                <div className="flex flex-col">
                  <p>
                    {t("labels.email")}: {user.email}
                  </p>
                  <p>
                    {t("labels.role")}: {user.role}
                  </p>
                  <p>
                    {t("labels.id")}: {user.id}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </>
      )}
    </div>
  );
}
