// TEST 11: R2 Claim 6 — "A server component rendered inside a client component
// is still executed on the server, but its output is serialized and sent to the client"
// 
// AND R2 Claim 13 — "app/layout.tsx (still a server component by default)"
//
// Our layout.tsx exports `metadata` — metadata export is ONLY allowed in Server Components.
// If the layout works with metadata, it proves it's still a Server Component even though
// it imports and renders ClientRoot and ThemeProvider.

// This page just confirms everything wired together works.

export default async function MetadataTestPage() {
  return (
    <div style={{ padding: "2rem" }}>
      <h1>Test 11: Layout Metadata Test</h1>
      <p>If you can see this page, it means:</p>
      <ul>
        <li>layout.tsx exports <code>metadata</code> (server-only feature) ✅</li>
        <li>layout.tsx is a Server Component that renders Client Component wrappers ✅</li>
        <li>This page is an async Server Component under those wrappers ✅</li>
      </ul>
      <p><strong>R2 Claim 6:</strong> Server components inside client wrappers still execute on server — <strong>CONFIRMED</strong></p>
      <p><strong>R2 Claim 13:</strong> layout.tsx is still a server component by default — <strong>CONFIRMED</strong></p>
    </div>
  );
}
