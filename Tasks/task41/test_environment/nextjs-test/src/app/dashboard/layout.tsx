"use client";

// TEST 5: Dashboard layout with 'use client' directive
// R2 claims: "every descendant of dashboard/layout.tsx will be treated as a client component"
// This tests whether pages under this layout are forced to become Client Components

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <section>
      <nav style={{ padding: "1rem", borderBottom: "1px solid #ccc" }}>
        <strong>Dashboard (use client layout)</strong>
      </nav>
      {children}
    </section>
  );
}
