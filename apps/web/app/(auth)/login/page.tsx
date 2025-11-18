"use client";
import { useMutation } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";
import { FormEvent } from "react";
import { toast } from "sonner";
import { loginAction } from "@/app/(auth)/actions";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import Link from "next/link";

export default function LoginPage() {
  const router = useRouter();
  const t = useTranslations("LoginPage");

  // login mutation
  const handleLogin = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.target as HTMLFormElement);
    const email = formData.get("email") as string;
    const password = formData.get("password") as string;
    if (!email || !password) {
      toast.error(t("errors.missingFields"));
      return false;
    }

    await loginAction(email, password);
    return true;
  };

  const formMutation = useMutation({
    mutationFn: handleLogin,
    onSuccess: () => {
      // we need to revalidate the path to update the auth state
      router.refresh();
      // then redirect to the weather page
      router.push("/");
    },
    onError: (error) => {
      const message =
        error instanceof Error ? error.message : t("errors.loginFailed");
      toast.error(message);
    },
  });

  return (
    <div className="w-full h-full flex flex-col items-center justify-center gap-4">
      <form
        className="flex flex-col p-2 gap-4 rounded-md border border-accent max-w-sm w-full"
        onSubmit={(e) => formMutation.mutate(e)}
      >
        <p>{t("title")}</p>
        <section className="flex flex-col gap-1 text-muted-foreground w-full">
          <label htmlFor={t("email")}>{t("email")}</label>
          <Input
            className="text-primary w-full"
            type="email"
            name="email"
            required={true}
          />
        </section>
        <section className="flex flex-col gap-1 text-muted-foreground w-full">
          <label htmlFor={t("password")}>{t("password")}</label>
          <Input
            className="text-primary w-full"
            type="password"
            name="password"
            required={true}
          />
        </section>
        <Button type="submit">
          {formMutation.isPending ? t("buttons.loggingIn") : t("buttons.login")}
        </Button>
      </form>
      <Link href="/register">
        <span className="text-muted-foreground hover:text-primary transition-colors duration-150">
          {t("links.register")}
        </span>
      </Link>
    </div>
  );
}
