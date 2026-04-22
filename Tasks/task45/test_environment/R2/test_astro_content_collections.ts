// Test file to VERIFY that R2's Astro content collections usage is CORRECT
// R2 claims at lines 542-552 to use getEntry from 'astro:content'

// This is TypeScript but represents Astro code
// Cannot compile without Astro environment, but can verify the API exists

/*
 * R2's code (lines 542-552):
 *
 * import { getEntry } from 'astro:content';
 * import Layout from '../../layouts/Layout.astro';
 * import DemoWrapper from '../../components/DemoWrapper.astro';
 *
 * const { slug } = Astro.params;
 * const lesson = await getEntry('lessons', slug);
 */

// VERIFICATION via Astro Documentation:
//
// 1. ✅ 'astro:content' module exists
//    Source: https://docs.astro.build/en/reference/modules/astro-content/
//
// 2. ✅ getEntry() function exists with signature:
//    getEntry(collection: string, slug: string): Promise<CollectionEntry | undefined>
//    Source: https://docs.astro.build/en/reference/modules/astro-content/#getentry
//
// 3. ✅ Usage pattern is correct:
//    const entry = await getEntry('blog', 'entry-1');
//
// 4. ✅ Astro.params is correct for dynamic routes like [slug].astro
//    Source: https://docs.astro.build/en/reference/api-reference/#astroparams

// Example of CORRECT usage (from Astro docs):
const correctUsageExample = `
---
import { getEntry } from 'astro:content';

const { slug } = Astro.params;
const blogPost = await getEntry('blog', slug);

if (!blogPost) {
  return Astro.redirect('/404');
}

const { Content } = await blogPost.render();
---

<Layout title={blogPost.data.title}>
  <Content />
</Layout>
`;

// VERIFICATION via web search results:
//
// From Astro docs:
// "getEntry() is a function that retrieves a single collection entry by
//  collection name and the entry id. It was added in Astro version 2.5.0."
//
// Function signature:
// "({ collection: CollectionKey, id: string }) => Promise<CollectionEntry | undefined>"

export const verification = {
  apiExists: true,
  correctUsage: true,
  documentation: 'https://docs.astro.build/en/reference/modules/astro-content/',
  conclusion: 'R2\'s Astro content collections usage is CORRECT'
};

/*
 * CONCLUSION: R2 correctly uses Astro's content collections API
 * This is a STRENGTH of R2's response
 */
