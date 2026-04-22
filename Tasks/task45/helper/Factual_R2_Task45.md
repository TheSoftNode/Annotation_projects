Use **GitHub Codespaces** for the main test run, and your **Mac browser** to open the forwarded dev port and inspect the page and console. That is the fairest setup here because the response mixes two CLIs, Astro SSR config, Angular libraries, and Web Components. For prerequisites, Astro currently requires **Node.js v22.12.0 or higher** and Angular currently requires **Node.js v20.19.0 or newer**, so **Node 22.x** is the safest shared target. Angular’s install docs also say to install the CLI with npm install \-g @angular/cli. ([Astro Docs](https://docs.astro.build/en/install-and-setup/))

I’m treating every **concrete, externally checkable statement, API usage, command, config option, or architecture claim** as a factual claim.

## **1\. Claim breakdown**

1. Claim: "content/ \# Markdown lessons (Astro content collections)"  
   Breakdown: this says the content collection lives under content/. Astro’s content-collections docs show collections configured under **src/content** via src/content.config.ts, and older/current docs consistently describe content collections as living in the reserved src/content/ directory. This claim is **disputed** by Astro’s docs. ([Astro Docs](https://docs.astro.build/en/guides/content-collections/))  
2. Claim: "\*\*Content Delivery\*\* | Astro | Blazing-fast static content, perfect for lessons"  
   Breakdown: the “perfect for lessons” part is opinion. The concrete part is that Astro is suited to content-heavy/static delivery. Astro’s docs describe content collections and Markdown as recommended ways to handle content, and Astro supports static output by default as well as content-first workflows. This is **broadly supported**, though the “blazing-fast” wording is marketing language rather than a measurable doc claim. ([Astro Docs](https://docs.astro.build/en/guides/markdown-content/?utm_source=chatgpt.com))  
3. Claim: "\*\*Dynamic Demos\*\* | Angular Web Components | Full framework power without framework lock-in"  
   Breakdown: Angular’s docs do support Angular components packaged as custom elements, and they say those custom elements can be used like normal HTML elements. The “without framework lock-in” part is opinion, not a primary-doc fact. The concrete custom-elements part is **supported**. ([Angular](https://angular.dev/guide/elements))  
4. Claim: "\*\*SSR\*\* | Astro \+ Angular Elements | Pre-rendered HTML with client-side hydration"  
   Breakdown: Astro docs support SSR/server output **after adding an adapter**. Angular docs support SSR and hydration for Angular applications. But I did **not** find primary docs establishing this exact combined pattern of **Astro SSR \+ Angular Elements hydration** as an official supported integration. So this is **not established by the primary docs I checked**. ([Astro Docs](https://docs.astro.build/en/guides/on-demand-rendering/))  
5. Claim: "\*\*State Management\*\* | Custom Events | Native browser APIs for component communication"  
   Breakdown: Angular’s custom-elements docs explicitly say component outputs are dispatched as HTML **Custom Events** and map into the browser event system. This is **supported**. ([Angular](https://angular.dev/guide/elements))  
6. Claim: "Web Component-\>\>Angular: Bootstraps in shadow DOM"  
   Breakdown: Angular styling docs say Shadow DOM only happens when ViewEncapsulation.ShadowDom is explicitly enabled. The provided component code does **not** enable it. Angular’s custom-elements docs say custom elements self-bootstrap, but they do not say they bootstrap in Shadow DOM by default. This claim is **disputed** by Angular’s docs. ([Angular](https://angular.dev/guide/elements))  
7. Claim: "| |alpha, beta, heads, tails|state-changed | Yes (scoped styles) |"  
   Breakdown: the attribute side is broadly aligned with Angular custom-elements docs, which say input properties map to attributes and outputs map to Custom Events. But the **“Shadow DOM: Yes”** part is **disputed** by Angular’s styling docs because Shadow DOM requires explicit ViewEncapsulation.ShadowDom, which the code does not set. ([Angular](https://angular.dev/guide/elements))  
8. Claim: "npm create astro@latest astro-bayesian \-- \--template minimal"  
   Breakdown: Astro docs support npm create astro@latest and support using templates/starters. So the command pattern is **supported** in principle. ([Astro Docs](https://docs.astro.build/en/install-and-setup/))  
9. Claim: "ng new angular \--create-application=false"  
   Breakdown: Angular’s ng new docs say create-application set to false creates an **empty workspace with no initial application**, and then you can use ng generate application. This is **supported**. ([Angular](https://angular.dev/cli/new?utm_source=chatgpt.com))  
10. Claim: "ng generate library coin-demo \--prefix=bd"  
    Breakdown: Angular’s CLI docs say ng generate library \[name\] creates a new library project in the Angular workspace, and prefix is a valid option. This is **supported**. ([Angular](https://angular.dev/cli/generate/library))  
11. Claim: "ng generate library linreg-demo \--prefix=bd"  
    Breakdown: same as above. This is **supported**. ([Angular](https://angular.dev/cli/generate/library))  
12. Claim: "npm install plotly.js marked @angular/elements @webcomponents/webcomponentsjs"  
    Breakdown: Angular’s custom-elements docs explicitly support installing @angular/elements. But Angular also says custom elements are available on all browsers Angular supports, so the need for @webcomponents/webcomponentsjs is **not established** by the primary docs I checked. I did not verify plotly.js or marked from their primary docs in this pass. ([Angular](https://angular.dev/guide/elements))  
13. Claim: "\#\#\# 2\. Angular Web Components (SSR-Ready)"  
    Breakdown: I did **not** find primary Angular or Astro docs saying Angular custom elements are “SSR-ready” in the exact sense implied here. Angular SSR docs discuss rendering Angular applications; Angular elements docs discuss custom elements. This exact combined claim is **not established by the primary docs I checked**. ([v18.angular.dev](https://v18.angular.dev/guide/ssr/))  
14. Claim: "const demo \= document.querySelector('\<%= props.componentName %\>');"  
    Breakdown: this is code, but it also implies Astro supports EJS-style \<%= ... %\> interpolation inside .astro. Astro syntax docs describe Astro templates as HTML with **JSX-like expressions using curly braces**, not EJS syntax. This usage is **disputed** by Astro syntax docs. ([Astro Docs](https://docs.astro.build/en/reference/astro-syntax/))  
15. Claim: "\<%=\\\<${props.componentName} ${attrs}\>\</${props.componentName}\>\`%\>"\`  
    Breakdown: same issue. Astro docs show curly-brace and JSX-like expressions, not EJS tags. This is **disputed** by Astro syntax docs. ([Astro Docs](https://docs.astro.build/en/reference/astro-syntax/))  
16. Claim: "const attrs \= Object.entries(props.attributes || {})"  
    Breakdown: Astro component props docs say props are available on the **Astro.props** global in frontmatter. I did not find support for a default props variable in .astro frontmatter. This is **disputed** by Astro’s component-props docs. ([Astro Docs](https://docs.astro.build/en/basics/astro-components/))  
17. Claim: "const lesson \= await getEntry('lessons', slug);"  
    Breakdown: getEntry() is a real Astro content API and is **supported**, assuming the lessons collection is actually configured. ([Astro Docs](https://docs.astro.build/en/reference/modules/astro-content/?utm_source=chatgpt.com))  
18. Claim: "\<Content /\>" in src/pages/lessons/\[slug\].astro  
    Breakdown: Astro’s content docs say that after getEntry(), you use render() from astro:content to obtain the \<Content /\> component. The response’s file imports getEntry only and never calls render(). This implementation is **disputed** by Astro’s documented content-rendering pattern. ([Astro Docs](https://docs.astro.build/en/guides/content-collections/?utm_source=chatgpt.com))  
19. Claim: "output: 'server'" in astro.config.mjs  
    Breakdown: Astro docs support output: 'server', but only **after adding an adapter**. The same docs also say server-side rendering requires an adapter, and Astro has an error page specifically for adapter/output mismatch. Because the response sets output: 'server' but shows no adapter, the config as presented is **incomplete / disputed as runnable**. ([Astro Docs](https://docs.astro.build/en/guides/on-demand-rendering/))  
20. Claim: "// Pre-render Angular components for SSR" inside the Vite plugin hook  
    Breakdown: transformIndexHtml is a Vite hook, but I did **not** find Astro or Angular primary docs supporting this exact approach as a valid Angular SSR implementation inside Astro. Angular SSR docs describe @angular/ssr, CommonEngine, server bootstrapping, and hydration for Angular applications. So this exact SSR claim is **not established by the primary docs I checked**. ([v18.angular.dev](https://v18.angular.dev/guide/ssr/))  
21. Claim: "\\"build:angular\\": \\"ng build coin-demo \--prod && ng build linreg-demo \--prod\\""  
    Breakdown: Angular’s current docs describe production builds via \--configuration production and document that ng build uses the production configuration by default. I did **not** find current Angular docs supporting \--prod. So this exact CLI usage is **not supported by the current docs I checked**. ([Angular](https://angular.dev/reference/configs/workspace-config))  
22. Claim: "\\"dev:angular\\": \\"ng serve coin-demo \--port 4200\\""  
    Breakdown: Angular’s ng serve docs say the project argument can be an application or a library, but Angular’s library docs also say a library **cannot run on its own** and build docs say generated libraries use the **@angular/build:ng-packagr** builder by default. So this exact claim is **at best unproven and likely problematic for a generated library workspace**. ([Angular](https://angular.dev/cli/serve))  
23. Claim: "1. \[ \] Create Astro content collections for lessons"  
    Breakdown: as a task, this is fine. As an implied architecture fact, Astro docs do support content collections for content like lessons or docs. This is **supported in general**. ([Astro Docs](https://docs.astro.build/en/guides/content-collections/?utm_source=chatgpt.com))  
24. Claim: "3. \[ \] Implement SSR-compatible Angular Elements"  
    Breakdown: I did **not** find primary Angular docs explicitly documenting “SSR-compatible Angular Elements” as a supported feature set. Angular documents SSR for applications and Angular Elements for custom elements, but I did not find an official bridge doc for this exact claim. This is **not established by the primary docs I checked**. ([v18.angular.dev](https://v18.angular.dev/guide/ssr/))  
25. Claim: "\#\#\# 1\. Performance Benefits" with the numbers "Initial Load | 12KB", "Time-to-Interactive | \< 500ms", "Bundle Size | 45KB", and the React comparison values  
    Breakdown: these are concrete benchmark claims. I found **no primary benchmark source** in the response and no official Astro/Angular docs supporting these exact numbers. These claims are **unsourced / not established**. There is no reliable way to accept them without an actual reproducible benchmark.  
26. Claim: "1. First load: Static HTML from Astro (SSR)"  
    Breakdown: Astro can render HTML server-side when configured with an adapter and output: 'server'. But calling that simply “static HTML from Astro (SSR)” mixes SSR and static language loosely. This is **partially supported in concept**, but the exact phrasing is imprecise. ([Astro Docs](https://docs.astro.build/en/guides/on-demand-rendering/))  
27. Claim: "2. Component visible: Load Angular bundle (lazy)"  
    Breakdown: lazy client loading is possible in web apps generally, but I did not find primary docs in this pass proving this specific implementation works as written. This is **not established by the primary docs I checked**.  
28. Claim: "3. User interaction: Full Angular change detection"  
    Breakdown: Angular custom elements do connect Angular change detection to the DOM according to Angular’s elements docs. This is **supported at the framework level**. ([Angular](https://angular.dev/guide/elements))  
29. Claim: "4. Network failure: Static preview remains functional"  
    Breakdown: this depends entirely on the implementation actually producing a valid fallback preview and the browser receiving it. I found **no primary doc support** for this specific guarantee. This is **not established**.

## **2\. Best device / OS for testing**

Use **GitHub Codespaces** for the terminal work and dependency setup. Use your **Mac browser** only for:

* opening the forwarded Astro dev port  
* checking the page output  
* checking the browser console and network tab

Why this is the fairest test:

* Astro currently wants **Node 22.12+**. Angular wants **Node 20.19+**. Codespaces makes it easy to pin Node 22 and keep the environment clean. ([Astro Docs](https://docs.astro.build/en/install-and-setup/))  
* You are testing **unchanged** code, so an isolated environment reduces “it failed because my laptop already had a weird setup” issues.

## **3\. Dependencies to install before testing**

In Codespaces, check:

node \-v

npm \-v

ng version

If node \-v is not **22.x**, switch it first. Astro requires v22.12.0 or higher, and Angular requires v20.19.0 or newer. ([Astro Docs](https://docs.astro.build/en/install-and-setup/))

If ng is missing, install Angular CLI:

npm install \-g @angular/cli

That is the command Angular’s install docs give. ([Angular](https://angular.dev/installation))

## **4\. Step-by-step manual code test plan**

Do **not** fix anything while testing. Paste the code exactly as written in the response.

### **Phase A — scaffold exactly as written**

1. Create a fresh Codespace folder.

Run:  
npm create astro@latest astro-bayesian \-- \--template minimal

cd astro-bayesian

2. Expected result: Astro project scaffolding should succeed if Node is compatible. Astro’s docs support create astro and template usage. ([Astro Docs](https://docs.astro.build/en/install-and-setup/))

Run:  
ng new angular \--create-application=false

cd angular

ng generate library coin-demo \--prefix=bd

ng generate library linreg-demo \--prefix=bd

cd ..

3. Expected result:  
   * ng new ... \--create-application=false should create an empty workspace. ([Angular](https://angular.dev/cli/new?utm_source=chatgpt.com))  
   * each ng generate library ... command should create a library project. ([Angular](https://angular.dev/cli/generate/library))

Install the dependencies exactly as written:  
npm install plotly.js marked @angular/elements @webcomponents/webcomponentsjs

4. Expected result:  
   * install should likely complete  
   * this does **not** prove all are necessary; it only proves the install command itself works

### **Phase B — add the files exactly as written**

5. Create the exact files and paste the exact code from the response, unchanged.  
6. Important: do **not** normalize paths, do **not** rename folders, do **not** replace content/ with src/content/, and do **not** fix props/\<%= ... %\>/\<Content /\>.

### **Phase C — first static validation pass**

From the Astro project root, run:  
npm run build

7. Expected result: this is likely where you get your **first hard failure**.  
8. Save the first terminal error exactly as printed.

Likely early failure points from the unchanged code:

Astro syntax errors from EJS-style tags like:  
\<%= props.componentName %\>

* because Astro docs describe JSX-like curly-brace expressions, not EJS syntax. ([Astro Docs](https://docs.astro.build/en/reference/astro-syntax/))

Astro frontmatter error from:  
props.attributes

* because Astro props are documented on Astro.props. ([Astro Docs](https://docs.astro.build/en/basics/astro-components/))  
* content/render error in \[slug\].astro because \<Content /\> is used without the documented render() call. ([Astro Docs](https://docs.astro.build/en/guides/content-collections/?utm_source=chatgpt.com))  
* server-output/adapter issue because output: 'server' is set without an adapter. ([Astro Docs](https://docs.astro.build/en/guides/on-demand-rendering/))

### **Phase D — Angular build checks**

Enter the Angular workspace:  
cd angular

ng build coin-demo

ng build linreg-demo

9.   
10. Expected result:  
* these may fail on compile errors in the provided Angular code  
* save the first compiler error exactly

Likely Angular-side failure points from the unchanged code:

* import { bayesCoin } from './bayes-coin'; but the sample bayes-coin.ts shows named exports, not a bayesCoin namespace object  
* this.dispatchEvent(...) inside a component class, while Angular custom-element docs describe **outputs** mapping to Custom Events, not component classes directly dispatching DOM events this way ([Angular](https://angular.dev/guide/elements))  
* \#priorPosterior and \#predictive are Angular template refs, but Plotly.newPlot('priorPosterior', ...) is trying to target string IDs; the template does not provide id="priorPosterior" or id="predictive"  
* direct window access in the constructor is risky for SSR; Angular SSR docs warn that browser globals like window and document are not available on the server. ([v18.angular.dev](https://v18.angular.dev/guide/ssr/))

### **Phase E — package-script test exactly as written**

11. Return to the repo root and run the exact scripts if you added them exactly:

npm run build

npm run dev

12. Expected result:  
* build may fail because ng build ... \--prod is not documented in current Angular docs, which use \--configuration production and note production is the default for ng build anyway. ([Angular](https://angular.dev/reference/configs/workspace-config))  
* dev may fail because ng serve coin-demo is being aimed at a library, and Angular docs say a library cannot run on its own. ([Angular](https://angular.dev/tools/libraries))

### **Phase F — browser check if dev server actually starts**

13. If any dev server starts, open the forwarded port in your Mac browser.  
14. Check:  
* page renders or not  
* browser console errors  
* network failures for /angular-bundle.js  
* whether custom elements are defined  
* whether the lesson page can actually render content  
15. Expected browser-level problems if it reaches runtime:  
* custom elements not defined  
* no content rendered for lesson body  
* no charts because Plotly target nodes are wrong  
* lazy loader selecting the wrong DOM because of the EJS-style selector string

## **5\. What I would mark as the highest-risk inaccuracies before you even run it**

1. Claim: "content/ \# Markdown lessons (Astro content collections)"  
   Highest-risk because Astro docs point to src/content, not content/. ([Astro Docs](https://docs.astro.build/en/guides/content-collections/))  
2. Claim: "Web Component-\>\>Angular: Bootstraps in shadow DOM"  
   Highest-risk because Angular’s docs say Shadow DOM is opt-in via ViewEncapsulation.ShadowDom, and the provided component does not set it. ([Angular](https://angular.dev/guide/components/styling))  
3. Claim: "\<Content /\>" in the content-collection page without calling render()  
   Highest-risk because Astro docs explicitly show const { Content } \= await render(entry). ([Astro Docs](https://docs.astro.build/en/guides/content-collections/?utm_source=chatgpt.com))  
4. Claim: "output: 'server'" without an adapter  
   Highest-risk because Astro’s SSR docs say server output requires an adapter. ([Astro Docs](https://docs.astro.build/en/guides/on-demand-rendering/))  
5. Claim: "\\"build:angular\\": \\"ng build coin-demo \--prod && ng build linreg-demo \--prod\\""  
   Highest-risk because current Angular docs do not support this exact documented form. ([Angular](https://angular.dev/reference/configs/workspace-config))  
6. Claim: "\\"dev:angular\\": \\"ng serve coin-demo \--port 4200\\""  
   Highest-risk because the generated project is a library, and Angular docs say a library cannot run on its own. ([Angular](https://angular.dev/tools/libraries))

When you run it, send me:

* the exact terminal error  
* the exact browser console error  
* which step it failed on

and I’ll map each failure back to the exact claim number above.

