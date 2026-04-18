// TEST 1 & 2: This is an ASYNC page (no "use client" directive).
// If R1 is correct, this should FAIL because children are "forced" to be client components.
// Client Components CANNOT be async (Next.js docs).
// If this works, R1's core claim is WRONG and R2's core claim is RIGHT.

export default async function AboutPage() {
  // Simulate server-side work (only possible in Server Components)
  const timestamp = new Date().toISOString();

  return (
    <div style={{ padding: "2rem" }}>
      <h1>About Page (Async Server Component)</h1>
      <p>This page is an async Server Component wrapped inside ClientRoot + ThemeProvider.</p>
      <p><strong>Server timestamp:</strong> {timestamp}</p>
      <p>
        If you can see this page without errors, it proves that wrapping children
        in a client component does NOT force all children to become client components.
      </p>
      <p><strong>R1 claim &quot;all children forced to be client&quot;:</strong> DISPROVEN</p>
      <p><strong>R2 claim &quot;children stay server unless they use client features&quot;:</strong> SUPPORTED</p>
    </div>
  );
}
