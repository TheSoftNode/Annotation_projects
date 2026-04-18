"use client";

// TEST 8: Module dependency tree test
// This client component IMPORTS SimpleGreeting directly.
// Per React docs, imported components under a "use client" module
// become part of the client bundle (module dependency tree).
// R2 claims 2, 3, 18 oversimplify this — they say components stay server
// "unless they use client features", but React says the import path matters too.

import SimpleGreeting from "@/components/SimpleGreeting";

export default function ClientImporter() {
  return (
    <div style={{ border: "2px solid blue", padding: "1rem", margin: "1rem" }}>
      <h3>Client Importer (has &quot;use client&quot;)</h3>
      <p>SimpleGreeting is IMPORTED here, so it becomes part of the client module graph:</p>
      <SimpleGreeting name="Imported-Into-Client" />
    </div>
  );
}
