# Prompt

**Conversation History:**

The user is migrating a Next.js app from the Pages Router to the App Router. They explained that their `_app.tsx` uses `useEffect` hooks and acts as an HTML base for pages (like `_document.tsx`). The assistant provided a detailed migration guide showing how to:

1. Create `app/layout.tsx` as the root layout (replacing `_document.tsx`)
2. Move `useEffect` logic into a `"use client"` wrapper component (`ClientRoot.tsx`)
3. Wrap `{children}` in `layout.tsx` with the client wrapper
4. Migrate page files to the `app/` directory structure

The assistant's migration guide included code examples for `layout.tsx` and `ClientRoot.tsx`, a comparison table, a checklist, and an FAQ section.

**Follow-up Prompt:**

> If I create a wrapper for my context providers, that is a client component, place it in the layout.tsx and wrap `children` with it. Will that force all children to be client components as well?
