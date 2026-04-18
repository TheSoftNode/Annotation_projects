"use client";

// Client component that receives props from a server component
export default function ClientReceiver({ data }: { data: { name: string; count: number } }) {
  return (
    <div style={{ border: "2px solid green", padding: "1rem", margin: "1rem" }}>
      <h3>Client Receiver Component</h3>
      <p>Received serializable data: name=&quot;{data.name}&quot;, count={data.count}</p>
    </div>
  );
}
