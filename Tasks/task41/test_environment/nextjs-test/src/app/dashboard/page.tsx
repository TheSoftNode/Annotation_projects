// TEST 5: R2's "every descendant" claim
// R2 says: "Now every descendant of dashboard/layout.tsx will be treated as a client component
//           because the boundary is set at that layout file."
// This is the MOST DISPUTED claim in R2.

// We test this with an async page under a 'use client' layout.
// If it works -> R2's claim 16 is WRONG (descendants are NOT all forced to be client)
// If it errors -> R2's claim 16 might be right

export default async function DashboardPage() {
  const time = new Date().toISOString();

  return (
    <div style={{ padding: "2rem" }}>
      <h1>Dashboard Page (Async - Under &apos;use client&apos; Layout)</h1>
      <p>This page is an async Server Component under a dashboard layout that has &apos;use client&apos;.</p>
      <p><strong>Server time:</strong> {time}</p>
      <p>
        If this renders without errors, R2&apos;s claim that &quot;every descendant of a
        &apos;use client&apos; layout will be treated as a client component&quot; is WRONG.
      </p>
    </div>
  );
}
