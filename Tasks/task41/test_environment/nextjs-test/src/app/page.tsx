// Home page - Server Component (no "use client" directive)
// Wrapped by ClientRoot + ThemeProvider in layout.tsx

import Link from "next/link";

export default function Home() {
  return (
    <div style={{ padding: "2rem", fontFamily: "sans-serif" }}>
      <h1>RSC Provider Boundary Tests</h1>
      <p>Testing whether wrapping children in client components forces them to be client components.</p>

      <nav style={{ marginTop: "2rem" }}>
        <h2>Test Pages:</h2>
        <ul style={{ lineHeight: "2" }}>
          <li>
            <Link href="/about">Test 1 &amp; 2: Async About Page</Link>
            {" "}- Async server component under ClientRoot + ThemeProvider
          </li>
          <li>
            <Link href="/server-data">Test 3: Server Data Page</Link>
            {" "}- Async page with server-side data fetching
          </li>
          <li>
            <Link href="/hook-test">Test 4: Hook Test</Link>
            {" "}- Server component using useContext (should error)
          </li>
          <li>
            <Link href="/dashboard">Test 5: Dashboard</Link>
            {" "}- Async page under &apos;use client&apos; layout
          </li>
          <li>
            <Link href="/theme-consumer">Test 6: Theme Consumer</Link>
            {" "}- Proper client component consuming context
          </li>
        </ul>
      </nav>
    </div>
  );
}
