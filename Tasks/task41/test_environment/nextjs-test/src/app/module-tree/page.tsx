// TEST 8: Module dependency tree vs render tree
// This tests R2 Claims 2, 3, 15, 18 — the oversimplification that
// components stay server "unless they use client features."
//
// Reality: A component ALSO becomes client when imported into a "use client" module
// (module dependency tree), even if it has no hooks.
//
// This page demonstrates BOTH paths side-by-side:
// 1. SimpleGreeting IMPORTED into ClientImporter -> becomes client (module dep)
// 2. SimpleGreeting as an ASYNC server page under the client wrappers -> stays server

import ClientImporter from "@/components/ClientImporter";
import SimpleGreeting from "@/components/SimpleGreeting";

export default async function ModuleTreeTestPage() {
  // This async function proves THIS page is a Server Component
  const serverTime = new Date().toISOString();

  return (
    <div style={{ padding: "2rem" }}>
      <h1>Test 8: Module Dependency Tree vs Render Tree</h1>
      <p><strong>Server time:</strong> {serverTime}</p>

      <h2>Path A: SimpleGreeting imported into a Client module</h2>
      <p>Below, ClientImporter (a &quot;use client&quot; file) imports SimpleGreeting directly.
         SimpleGreeting becomes part of the client module graph — even though it has NO hooks.</p>
      <ClientImporter />

      <h2 style={{ marginTop: "2rem" }}>Path B: SimpleGreeting rendered in this Server page</h2>
      <p>Here, SimpleGreeting is imported into THIS file (a Server Component).
         It stays a Server Component because the import is in a server module.</p>
      <SimpleGreeting name="Imported-Into-Server" />

      <div style={{ marginTop: "2rem", padding: "1rem", backgroundColor: "#f0f0f0" }}>
        <h3>What this proves about R2&apos;s claims:</h3>
        <ul>
          <li><strong>R2 Claim 2:</strong> &quot;A child stays server unless it uses client features&quot; — <strong>OVERSIMPLIFIED</strong>.
            SimpleGreeting has no hooks, yet it becomes client when imported into a client module.</li>
          <li><strong>R2 Claim 3:</strong> &quot;client-ness is local to the file that declares it&quot; — <strong>OVERSIMPLIFIED</strong>.
            The same file (SimpleGreeting) has both server and client usages depending on where it&apos;s imported.</li>
          <li><strong>R2 Claim 18:</strong> &quot;Only those that use client-only features need use client&quot; — <strong>OVERSIMPLIFIED</strong>.
            Components imported into use client modules also become client.</li>
        </ul>
      </div>
    </div>
  );
}
