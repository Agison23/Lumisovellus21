"use client";
import { paths } from "@lumisovellus/api-client-web";
import { DialogTitle } from "@radix-ui/react-dialog";
import { useMutation, useQuery } from "@tanstack/react-query";
import { Edit } from "lucide-react";
import { useTranslations } from "next-intl";
import { ChangeEvent, useMemo, useState } from "react";
import { toast } from "sonner";
import { getAccessTokenAction } from "@/app/(auth)/actions";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectTrigger,
  SelectValue,
  SelectItem,
} from "@/components/ui/select";
import { apiUrl } from "@/lib/map/loaders";
export type Users =
  paths["/api/v1/users"]["get"]["responses"]["200"]["content"]["application/json"]["data"];

export default function DashboardPage() {
  const t = useTranslations("Dashboard.UsersPage");

  const {
    data: users = [],
    isLoading,
    isError,
    refetch,
  } = useQuery({
    queryKey: ["users"],
    queryFn: async () => {
      const accessToken = await getAccessTokenAction();
      if (!accessToken) {
        throw new Error("User is not authenticated");
      }
      type UsersResponse =
        paths["/api/v1/users"]["get"]["responses"]["200"]["content"]["application/json"];
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
                  <EditUserDialog user={user} t={t} refetch={refetch} />
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

function EditUserDialog({
  user,
  t,
  refetch,
}: {
  user: Users[number];
  t: (key: string, params?: Record<string, string>) => string;
  refetch: () => void;
}) {
  const [open, setOpen] = useState(false);

  const [editableUser, setEditableUser] = useState<Users[number]>(
    JSON.parse(JSON.stringify(user)),
  );

  const closeDialog = () => {
    setEditableUser(JSON.parse(JSON.stringify(user)));
    setOpen(false);
  };

  const mutation = useMutation({
    mutationFn: async (updatedUser: Users[number]) => {
      type UpdateUserBody =
        paths["/api/v1/users/{id}"]["put"]["requestBody"]["content"]["application/json"];

      const body: UpdateUserBody = {
        firstName: updatedUser.firstName,
        lastName: updatedUser.lastName ?? "",
        email: updatedUser.email ?? "",
        phoneNumber: updatedUser.phoneNumber ?? "",
        role: updatedUser.role ?? "",
      };
      const accessToken = await getAccessTokenAction();
      if (!accessToken) {
        throw new Error("User is not authenticated");
      }
      const res = await fetch(`${apiUrl}/api/v1/users/${updatedUser.id}`, {
        method: "PUT",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(body),
      });
    },
    onSuccess: () => {
      toast.success(t("editDialog.success.saveSuccessful"));
      refetch();
      setOpen(false);
    },
    onError: () => {
      toast.error(t("editDialog.errors.saveFailed"));
    },
  });

  const handleSave = () => {
    mutation.mutate(editableUser);
  };

  const hasBeenModified = JSON.stringify(user) !== JSON.stringify(editableUser);

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button variant="outline" size="icon" className="p1">
          <Edit />
        </Button>
      </DialogTrigger>
      <DialogContent className="max-h-[80vh] w-full grid-rows-[auto_1fr] overflow-hidden flex flex-col gap-4">
        <DialogHeader>
          <DialogTitle>
            {t("editDialog.title", {
              email: user.email ? user.email : "",
            })}
          </DialogTitle>
        </DialogHeader>
        <div className="flex flex-col gap-2 min-h-0">
          <div className="flex gap-2 w-full">
            <div className="flex flex-col gap-1 w-full">
              <label className="text-xs">{t("editDialog.firstName")}</label>
              <Input
                value={editableUser.firstName}
                onChange={(e) =>
                  setEditableUser((prev) => ({
                    ...prev,
                    firstName: e.target.value,
                  }))
                }
              />
            </div>
            <div className="flex flex-col gap-1 w-full">
              <label className="text-xs">{t("editDialog.lastName")}</label>
              <Input
                value={editableUser.lastName ?? ""}
                onChange={(e) =>
                  setEditableUser((prev) => ({
                    ...prev,
                    lastName: e.target.value,
                  }))
                }
              />
            </div>
          </div>
          <div className="flex flex-col gap-1 w-full">
            <label className="text-xs">{t("editDialog.email")}</label>
            <Input
              value={editableUser.email ?? ""}
              onChange={(e) =>
                setEditableUser((prev) => ({
                  ...prev,
                  email: e.target.value,
                }))
              }
            />
          </div>
          <div className="flex flex-col gap-1 w-full">
            <label className="text-xs">{t("editDialog.role")}</label>
            <Select
              value={editableUser.role}
              onValueChange={(value) =>
                setEditableUser((prev) => ({ ...prev, role: value }))
              }
            >
              <SelectTrigger>
                <SelectValue placeholder={t("editDialog.rolePlaceholder")} />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="ADMIN">ADMIN</SelectItem>
                <SelectItem value="RESCUE">RESCUE</SelectItem>
                <SelectItem value="NORMAL">NORMAL</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div className="flex gap-2 w-full shrink-0">
            <Button
              onClick={() => closeDialog()}
              variant="outline"
              className="flex-1"
              disabled={mutation.isPending}
            >
              {t("editDialog.buttons.cancel")}
            </Button>
            <Button
              disabled={mutation.isPending || !hasBeenModified}
              onClick={() => handleSave()}
              className="flex-1"
            >
              {mutation.isPending
                ? t("editDialog.buttons.saving")
                : t("editDialog.buttons.save")}
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
