import React, { useState, createContext } from "react";

const GlobalContext = createContext();

export function GlobalProvider({ children }) {
  const [language, setLanguage] = useState("fi");

  function changeToLanguage(languageToChangeTo) {
    setLanguage(languageToChangeTo);
  }

  return (
    <GlobalContext.Provider
      value={{
        language,
        changeToLanguage,
      }}
    >
      {children}
    </GlobalContext.Provider>
  );
}

export default GlobalContext;
