// Helper: A simple component with NO "use client" and NO hooks.
// When IMPORTED into a "use client" module -> becomes client (module dependency)
// When PASSED as children to a client component -> stays server

export default function SimpleGreeting({ name }: { name: string }) {
  return <p>Hello, {name}! I am a simple greeting component.</p>;
}
