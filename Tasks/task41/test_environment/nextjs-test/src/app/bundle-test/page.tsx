// TEST 9: R2 Claim 5 — "everything inside it is sent to the browser as part of the same bundle"
// This tests whether Server Components passed as {children} to a Client Component
// actually end up in the client JS bundle.
//
// We use process.env (server-only) and check if it works.
// If it does, the component ran on the server, NOT in the browser bundle.

export default async function BundleTestPage() {
  // process.cwd() is a server-only Node.js API
  const cwd = process.cwd();
  const envKeys = Object.keys(process.env).length;

  return (
    <div style={{ padding: "2rem" }}>
      <h1>Test 9: Bundle Boundary Test</h1>
      <p>This page is wrapped by ClientRoot + ThemeProvider, but has no &quot;use client&quot;.</p>

      <h2>Server-only data:</h2>
      <ul>
        <li><strong>process.cwd():</strong> {cwd}</li>
        <li><strong>Number of env vars:</strong> {envKeys}</li>
      </ul>

      <div style={{ marginTop: "2rem", padding: "1rem", backgroundColor: "#f0f0f0" }}>
        <h3>What this proves:</h3>
        <p>If you see the working directory and env var count above, this page executed on the <strong>server</strong>,
           even though it&apos;s rendered inside client component wrappers.</p>
        <p><strong>R2 Claim 5</strong> says &quot;everything inside [a client boundary] is sent to the browser
           as part of the same bundle.&quot; This is <strong>NOT accurate</strong> for children passed via the
           slot pattern — they execute on the server and their OUTPUT is serialized to the client.</p>
      </div>
    </div>
  );
}
