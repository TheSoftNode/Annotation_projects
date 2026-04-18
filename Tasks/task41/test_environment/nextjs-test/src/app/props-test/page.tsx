// TEST 10: R2 Claim 11 — "They will simply receive whatever props you pass down"
// Tests serialization rules across the server/client boundary.
// React requires props crossing the boundary to be serializable.
// Functions, classes, etc. CANNOT cross the boundary.

// This is a Server Component page that passes a non-serializable prop
// to demonstrate the boundary constraint R2 glosses over.

import ClientReceiver from "@/components/ClientReceiver";

export default function PropsTestPage() {
  // A plain object (serializable) — should work
  const serialData = { name: "test", count: 42 };

  return (
    <div style={{ padding: "2rem" }}>
      <h1>Test 10: Props Serialization Test</h1>

      <h2>Serializable props (should work):</h2>
      <ClientReceiver data={serialData} />

      <div style={{ marginTop: "2rem", padding: "1rem", backgroundColor: "#f0f0f0" }}>
        <h3>What this proves:</h3>
        <p>R2 Claim 11 says server components &quot;will simply receive whatever props you pass down
           from the client wrapper.&quot; This is <strong>too broad</strong> — React imposes serialization
           rules on props crossing the server/client boundary. Only serializable values can cross.</p>
      </div>
    </div>
  );
}
