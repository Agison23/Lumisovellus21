import React, { useState, createContext } from "react";

const GlobalContext = createContext();

export function GlobalProvider({ children }) {
  const [language, setLanguage] = useState("en");

  function toggleFiEn() {
    if (language === "fi") {
      setLanguage("en");
    } else {
      setLanguage("fi");
    }
  }

  return (
    <GlobalContext.Provider
      value={{
        language,
        toggleFiEn,
      }}
    >
      {children}
    </GlobalContext.Provider>
  );
}

export default GlobalContext;
