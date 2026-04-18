"use client";

import { createContext, useState } from "react";

export const ThemeContext = createContext<{ theme: string; toggle: () => void }>({
  theme: "light",
  toggle: () => {},
});

// R2's pattern - a context provider client component
export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState("light");
  const toggle = () => setTheme((t) => (t === "light" ? "dark" : "light"));

  return (
    <ThemeContext.Provider value={{ theme, toggle }}>
      {children}
    </ThemeContext.Provider>
  );
}
