// eslint-disable-next-line unused-imports/no-unused-imports
import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";
import { cookies } from "next/headers";
import { NextIntlClientProvider } from "next-intl";
import { Toaster } from "sonner";
import Providers from "./providers";
import Nav from "@/components/app-nav";
import AppSidebar from "@/components/app-sidebar";
import { ThemeProvider } from "@/components/theme/theme-provider";
import {
  SidebarInset,
  SidebarProvider,
  SidebarTrigger,
} from "@/components/ui/sidebar";
import { AuthProvider } from "@/hooks/use-auth";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata = {
  title: "Snowledge",
  description: "Snowledge - Application for Pallastunturi",
};

export default async function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const cookieStore = await cookies();
  const defaultOpen = cookieStore.get("sidebar_state")?.value === "true";
  const accessToken = cookieStore.get("accessToken")?.value;

  let isLoggedIn = false;
  let user = null;
  if (accessToken) {
    const { verifyTokenAction } = await import("@/app/(auth)/actions");
    const verification = await verifyTokenAction(accessToken);
    isLoggedIn = verification.valid === true;
    user = verification.user;
  }

  return (
    <html lang="en" suppressHydrationWarning>
      <body className={`${geistSans.variable} ${geistMono.variable}`}>
        <NextIntlClientProvider>
          <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
            <AuthProvider isLoggedIn={isLoggedIn} user={user}>
              <SidebarProvider defaultOpen={defaultOpen}>
                <div className="w-[100dvw] h-[100dvh] flex flex-row overflow-hidden">
                  <AppSidebar />
                  <SidebarInset className="relative flex flex-col gap-2 flex-1">
                    <div className="w-max flex justify-start items-center absolute z-10 p-2">
                      <SidebarTrigger className="bg-background" />
                    </div>
                    <div className="flex-1 w-full h-full rounded-xl overflow-clip">
                      <Providers>
                        {children}
                        <Toaster position="bottom-left" />
                      </Providers>
                    </div>
                    <div className="w-full flex justify-center absolute bottom-0 sm:p-2 z-9999 pointer-events-none">
                      <Nav />
                    </div>
                  </SidebarInset>
                </div>
              </SidebarProvider>
            </AuthProvider>
          </ThemeProvider>
        </NextIntlClientProvider>
      </body>
    </html>
  );
}
