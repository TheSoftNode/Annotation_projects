"use client";

// TEST 6: Client component that properly consumes context
// This should work fine - it's a client component using useContext

import { useContext } from "react";
import { ThemeContext } from "@/providers/ThemeProvider";

export default function ThemeConsumerPage() {
  const { theme, toggle } = useContext(ThemeContext);

  return (
    <div style={{ padding: "2rem" }}>
      <h1>Theme Consumer (Client Component)</h1>
      <p>Current theme: <strong>{theme}</strong></p>
      <button onClick={toggle} style={{ padding: "0.5rem 1rem", marginTop: "1rem" }}>
        Toggle Theme
      </button>
      <p style={{ marginTop: "1rem" }}>
        This page has &quot;use client&quot; and properly uses useContext.
        R2 correctly says: &quot;Any component that wants to read that context with useContext must also be a client component.&quot;
      </p>
    </div>
  );
}
