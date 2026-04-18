// TEST 3: Async page with actual async data fetching
// This is the STRONGEST test - async functions are categorically impossible in Client Components.
// If this page renders, it's conclusive proof it's running as a Server Component.

async function getData() {
  // Simulating server-side data fetching
  return {
    message: "This data was fetched on the server",
    time: new Date().toISOString(),
    nodeVersion: process.version,
  };
}

export default async function ServerDataPage() {
  const data = await getData();

  return (
    <div style={{ padding: "2rem" }}>
      <h1>Server Data Page (Async with Data Fetching)</h1>
      <p>This page fetches data using an async function - only possible in Server Components.</p>
      <ul>
        <li><strong>Message:</strong> {data.message}</li>
        <li><strong>Server time:</strong> {data.time}</li>
        <li><strong>Node version:</strong> {data.nodeVersion}</li>
      </ul>
      <p>
        This page is wrapped by ClientRoot + ThemeProvider (both client components),
        yet it still works as an async Server Component with server-side data fetching.
      </p>
      <p><strong>R1 claim that server components &quot;cannot live inside the ClientRoot wrapper&quot;:</strong> DISPROVEN</p>
    </div>
  );
}
