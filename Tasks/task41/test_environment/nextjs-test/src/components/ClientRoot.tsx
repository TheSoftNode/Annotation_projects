"use client";

// R1's exact pattern - a client component wrapper
export default function ClientRoot({ children }: { children: React.ReactNode }) {
  return <div>{children}</div>;
}
