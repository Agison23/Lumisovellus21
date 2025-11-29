"use client";

import { paths } from "@lumisovellus/api-client-web";
import { createContext, ReactNode, useContext } from "react";

export type User =
  paths["/auth/login"]["post"]["responses"]["200"]["content"]["application/json"]["data"]["user"];

interface AuthContextType {
  isLoggedIn: boolean;
  user: User | null;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({
  children,
  isLoggedIn,
  user,
}: {
  children: ReactNode;
  isLoggedIn: boolean;
  user: User | null;
}) {
  return (
    <AuthContext.Provider value={{ isLoggedIn, user }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within AuthProvider");
  }
  return context;
}
