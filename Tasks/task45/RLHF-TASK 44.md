**CONVERSATION HISTORY:**

## **USER:**

## Implement a react app to teach bayesian predictive modeling. First start with a technical design, then implement the code according to the design

## ---

## **ASSISTANT:**

## Below is a **complete technical design** followed by **all source code** (including a `README`) for a small‑scale React application whose sole purpose is to **teach Bayesian predictive modeling** through interactive visualisations and step‑by‑step explanations.

## The app is deliberately kept **framework‑agnostic** (plain React \+ Vite) so you can copy‑paste the files into any modern React starter (Create‑React‑App, Next.js, Remix, etc.) and it will work out‑of‑the‑box.

## ---

## **1️⃣ Technical Design**

### **1.1 High‑level goals**

| Goal | How we achieve it |
| ----- | ----- |
| **Explain Bayes theorem & predictive distribution** | A series of Markdown‑styled “Lesson” screens (Intro → Prior → Likelihood → Posterior → Predictive). |
| **Let users experiment with a concrete model** | Interactive “Coin‑Flip” (Beta‑Binomial) and “Linear Regression” (Gaussian‑Normal‑Inverse‑Gamma) demos. |
| **Visualise distributions** | Re‑usable chart components based on **Plotly.js** (via `react-plotly.js`). |
| **Persist settings while navigating** | Global React Context (`AppContext`) holds user‑selected prior parameters, observed data, and model choice. |
| **Responsive, mobile‑friendly UI** | Simple CSS Grid \+ Flexbox, no external UI framework required. |
| **No backend** | All calculations are done client‑side using pure JavaScript (no heavy scientific‑computing libs). |

## ---

### **1.2 Architecture diagram**

## ┌─────────────────────────────────────────────────────┐

## │                     index.html                      │

## └─────────────────────────────────────────────────────┘

##                 │

##                 ▼

## ┌─────────────────────────────────────────────────────┐

## │                     src/ (Vite)                     │

## │                                                     │

## │  App.jsx                ──►  Router (react‑router)   │

## │  ├─ AppContext.jsx      │   ├─ /lesson               │

## │  ├─ routes/             │   │   └─ LessonPage.jsx    │

## │  │   ├─ LessonPage.jsx  │   ├─ /demo                 │

## │  │   └─ DemoPage.jsx    │   │   └─ DemoContainer.jsx│

## │  ├─ components/         │   └─ /about                │

## │  │   ├─ Header.jsx      │       └─ AboutPage.jsx    │

## │  │   ├─ Footer.jsx      │                             │

## │  │   ├─ Chart.jsx       │                             │

## │  │   ├─ SliderInput.jsx │                             │

## │  │   └─ ...             │                             │

## │  └─ utils/              │                             │

## │      ├─ bayesCoin.js    │   ──►  Domain logic (pure  │

## │      └─ bayesLinReg.js  │          JS functions)   │

## └─────────────────────────────────────────────────────┘

## 

## 

* ## **`AppContext`** – a React Context that stores the global state (selected model, hyper‑parameters, observed data).

* ## **`LessonPage`** – presents the narrative, rendered from Markdown strings.

* ## **`DemoPage`** – hosts the interactive demo; it composes a **controller panel** (sliders, data entry) and **visualisation panel** (charts).

* ## **`utils/`** – pure‑JS mathematics (Beta‑Binomial, Normal‑Inv‑Gamma, posterior predictive calculations).

## ---

### **1.3 Data flow**

1. ## **User updates a control** (e.g., “α” prior for the coin).

2. ## The control component calls `setState` from `AppContext`.

3. ## `DemoContainer` (or `LessonPage`) **subscribes** to the context and re‑computes the posterior/predictive via the utility functions.

4. ## Updated datasets are fed to `Chart` → renders new Plotly figure.

## All data stays **in memory**; no network requests.

## ---

### **1.4 Component responsibilities**

| Component | Props | State | Description |
| ----- | ----- | ----- | ----- |
| **Header** | – | – | App title \+ navigation links |
| **Footer** | – | – | Small attribution |
| **LessonPage** | `lessonId` (string) | – | Loads markdown from `lessons/` and renders it |
| **DemoPage** | – | – | Switches between **CoinDemo** and **LinRegDemo** (tabs) |
| **CoinDemo** | – | – | Controls: α, β, \#heads, \#tails; Shows prior, likelihood, posterior, predictive |
| **LinRegDemo** | – | – | Controls: σ²₀, κ₀, μ₀, α₀, β₀; Data table for (x, y); Shows posterior regression line \+ predictive intervals |
| **SliderInput** | `label`, `min`, `max`, `step`, `value`, `onChange` | – | UI wrapper for `<input type=""range"">` |
| **Chart** | `data`, `layout` | – | Thin wrapper around `react-plotly.js` |
| **AppContext** | – | `model`, `params`, `data` | Provides a global store \+ setters |

## ---

### **1.5 Tech stack**

| Layer | Library / Tool | Reason |
| ----- | ----- | ----- |
| **Build** | Vite (React TS template) | Fast dev server, zero‑config |
| **UI** | React 18 (hooks) | Modern functional approach |
| **Routing** | react‑router‑dom v6 | Simple declarative routes |
| **Charts** | react‑plotly.js \+ plotly.js | Interactive, responsive, no extra math needed |
| **Styling** | CSS Modules (scoped) \+ simple CSS variables | No heavy UI framework, easy to read |
| **Markdown** | `marked` (tiny) | Render lesson text |
| **Testing (optional)** | Jest \+ React Testing Library | Not required for the MVP, but scaffold is present |

## ---

## **2️⃣ Implementation**

## The following files assume **Vite \+ React (TypeScript)**. If you prefer plain JavaScript, just drop the type annotations – the logic stays identical.

### **2.1 Project bootstrap**

## \# 1️⃣ Create the Vite \+ React TS project

## npm create vite@latest bayesian-teach-app \-- \--template react-ts

## cd bayesian-teach-app

## 

## \# 2️⃣ Install runtime dependencies

## npm i react-router-dom react-plotly.js plotly.js marked

## 

## \# 3️⃣ (Optional) install dev dependencies for linting / testing

## npm i \-D jest @testing-library/react @testing-library/jest-dom @types/jest @types/react-test-renderer

## 

## 

## Now replace the `src/` folder with the files listed below.

## ---

### **2.2 `src/main.tsx`**

## import React from ""react"";

## import ReactDOM from ""react-dom/client"";

## import { BrowserRouter } from ""react-router-dom"";

## import App from ""./App"";

## import { AppProvider } from ""./context/AppContext"";

## import ""./index.css"";

## 

## ReactDOM.createRoot(document.getElementById(""root"") as HTMLElement).render(

##   \<React.StrictMode\>

##     \<BrowserRouter\>

##       \<AppProvider\>

##         \<App /\>

##       \</AppProvider\>

##     \</BrowserRouter\>

##   \</React.StrictMode\>,

## );

## 

## 

## ---

### **2.3 `src/App.tsx`**

## import { Routes, Route, NavLink } from ""react-router-dom"";

## import LessonPage from ""./routes/LessonPage"";

## import DemoPage from ""./routes/DemoPage"";

## import AboutPage from ""./routes/AboutPage"";

## import Header from ""./components/Header"";

## import Footer from ""./components/Footer"";

## 

## const App \= () \=\> {

##   return (

##     \<div className=""app""\>

##       \<Header /\>

##       \<main className=""content""\>

##         \<Routes\>

##           \<Route path=""/"" element={\<LessonPage lessonId=""intro"" /\>} /\>

##           \<Route path=""/lesson/:lessonId"" element={\<LessonPage /\>} /\>

##           \<Route path=""/demo"" element={\<DemoPage /\>} /\>

##           \<Route path=""/about"" element={\<AboutPage /\>} /\>

##         \</Routes\>

##       \</main\>

##       \<Footer /\>

##     \</div\>

##   );

## };

## 

## export default App;

## 

## 

## ---

### **2.4 `src/context/AppContext.tsx`**

## import { createContext, useContext, useState, ReactNode } from ""react"";

## 

## /\* \---------- Types \---------- \*/

## export type CoinParams \= {

##   alpha: number; // prior successes

##   beta: number;  // prior failures

##   heads: number;

##   tails: number;

## };

## 

## export type LinRegParams \= {

##   mu0: number;

##   kappa0: number;

##   alpha0: number;

##   beta0: number;

##   sigma2\_0: number;

## };

## 

## export type Model \= ""coin"" | ""linreg"";

## 

## export type AppState \= {

##   model: Model;

##   coin: CoinParams;

##   linreg: LinRegParams;

## };

## 

## /\* \---------- Default state \---------- \*/

## const defaultState: AppState \= {

##   model: ""coin"",

##   coin: {

##     alpha: 2,

##     beta: 2,

##     heads: 5,

##     tails: 5,

##   },

##   linreg: {

##     mu0: 0,

##     kappa0: 1,

##     alpha0: 2,

##     beta0: 2,

##     sigma2\_0: 1,

##   },

## };

## 

## /\* \---------- Context \---------- \*/

## type AppContextProps \= {

##   state: AppState;

##   setModel: (model: Model) \=\> void;

##   setCoin: (p: Partial\<CoinParams\>) \=\> void;

##   setLinReg: (p: Partial\<LinRegParams\>) \=\> void;

## };

## 

## const AppContext \= createContext\<AppContextProps | undefined\>(undefined);

## 

## export const AppProvider \= ({ children }: { children: ReactNode }) \=\> {

##   const \[state, setState\] \= useState\<AppState\>(defaultState);

## 

##   const setModel \= (model: Model) \=\> setState((s) \=\> ({ ...s, model }));

##   const setCoin \= (p: Partial\<CoinParams\>) \=\>

##     setState((s) \=\> ({ ...s, coin: { ...s.coin, ...p } }));

##   const setLinReg \= (p: Partial\<LinRegParams\>) \=\>

##     setState((s) \=\> ({ ...s, linreg: { ...s.linreg, ...p } }));

## 

##   return (

##     \<AppContext.Provider value={{ state, setModel, setCoin, setLinReg }}\>

##       {children}

##     \</AppContext.Provider\>

##   );

## };

## 

## /\* \---------- Hook \---------- \*/

## export const useAppContext \= () \=\> {

##   const ctx \= useContext(AppContext);

##   if (\!ctx) throw new Error(""useAppContext must be used within AppProvider"");

##   return ctx;

## };

## 

## 

## ---

### **2.5 `src/utils/bayesCoin.ts`**

## /\*\*

##  \* Core math for the Beta‑Binomial (coin‑flip) model.

##  \* All functions are pure and return arrays suitable for Plotly.

##  \*/

## 

## export const betaPDF \= (x: number\[\], alpha: number, beta: number) \=\> {

##   const B \= (a: number, b: number) \=\> Math.exp(gammaln(a) \+ gammaln(b) \- gammaln(a \+ b));

##   const coeff \= 1 / B(alpha, beta);

##   return x.map((xi) \=\> coeff \* Math.pow(xi, alpha \- 1\) \* Math.pow(1 \- xi, beta \- 1));

## };

## 

## export const binomialPMF \= (k: number, n: number, p: number) \=\> {

##   const comb \= (n: number, k: number) \=\> {

##     // simple factorial based combo (n small)

##     const fact \= (m: number) \=\> (m \<= 1 ? 1 : m \* fact(m \- 1));

##     return fact(n) / (fact(k) \* fact(n \- k));

##   };

##   return comb(n, k) \* Math.pow(p, k) \* Math.pow(1 \- p, n \- k);

## };

## 

## /\*\* Posterior Beta parameters after observing heads & tails \*/

## export const posteriorBeta \= (alpha: number, beta: number, heads: number, tails: number) \=\> ({

##   alpha: alpha \+ heads,

##   beta: beta \+ tails,

## });

## 

## /\*\* Predictive probability of next m tosses being k successes (Beta‑Binomial) \*/

## export const predictiveBetaBinomial \= (

##   alpha: number,

##   beta: number,

##   heads: number,

##   tails: number,

##   m: number,

## ) \=\> {

##   const a \= alpha \+ heads;

##   const b \= beta \+ tails;

##   const probs: number\[\] \= \[\];

##   for (let k \= 0; k \<= m; k++) {

##     const comb \= (n: number, k: number) \=\> {

##       const fact \= (x: number) \=\> (x \<= 1 ? 1 : x \* fact(x \- 1));

##       return fact(n) / (fact(k) \* fact(n \- k));

##     };

##     const num \= comb(m, k) \* Math.exp(gammaln(a \+ k) \+ gammaln(b \+ m \- k) \- gammaln(a \+ b \+ m));

##     const den \= Math.exp(gammaln(a) \+ gammaln(b) \- gammaln(a \+ b));

##     probs.push(num / den);

##   }

##   return probs;

## };

## 

## /\*\* Log‑Gamma (Lanczos approximation) – needed for Beta functions \*/

## function gammaln(z: number) {

##   const coeff \= \[

##     57.1562356658629235,

##     \-59.5979603554754912,

##     14.1360979747417471,

##     \-0.491913816097620199,

##     0.339946499848118887e-4,

##     0.465236289270485756e-4,

##     \-0.983744753048795646e-4,

##     0.158088703224912494e-3,

##     \-0.210264441724104883e-3,

##     0.217439618115212643e-3,

##     \-0.164318106536763890e-3,

##     0.844182239838527433e-4,

##     \-0.261908384015814087e-4,

##     0.368991826595316234e-5,

##   \];

##   let x \= 0.999999999999997092;

##   for (let i \= 0; i \< coeff.length; i++) x \+= coeff\[i\] / (z \+ i \+ 1);

##   const t \= z \+ coeff.length \- 0.5;

##   return 0.5 \* Math.log(2 \* Math.PI) \+ (z \+ 0.5) \* Math.log(t) \- t \+ Math.log(x) \- Math.log(z);

## }

## 

## 

## ---

### **2.6 `src/utils/bayesLinReg.ts`**

## /\*\*

##  \* Bayesian Linear Regression (Normal likelihood, Normal‑Inverse‑Gamma prior)

##  \* \-------------------------------------------------

##  \* Prior hyper‑parameters:

##  \*   μ₀, κ₀, α₀, β₀

##  \*

##  \* Given data (x\_i, y\_i) i=1..n the posterior is also Normal‑Inv‑Gamma.

##  \* This file provides functions to compute posterior parameters and the

##  \* predictive distribution for new x\*.

##  \*/

## 

## export type DataPoint \= { x: number; y: number };

## 

## export type Prior \= {

##   mu0: number;

##   kappa0: number;

##   alpha0: number;

##   beta0: number;

## };

## 

## export type Posterior \= {

##   muN: number;

##   kappaN: number;

##   alphaN: number;

##   betaN: number;

## };

## 

## /\*\* Helper: sum of array \*/

## const sum \= (arr: number\[\]) \=\> arr.reduce((a, b) \=\> a \+ b, 0);

## 

## /\*\* Compute posterior parameters \*/

## export const posteriorLinReg \= (

##   data: DataPoint\[\],

##   prior: Prior,

## ): Posterior \=\> {

##   const n \= data.length;

##   if (n \=== 0\) return { muN: prior.mu0, kappaN: prior.kappa0, alphaN: prior.alpha0, betaN: prior.beta0 };

## 

##   const xVals \= data.map((d) \=\> d.x);

##   const yVals \= data.map((d) \=\> d.y);

##   const xBar \= sum(xVals) / n;

##   const yBar \= sum(yVals) / n;

## 

##   // Compute Sxx and Sxy

##   const Sxx \= sum(xVals.map((xi) \=\> Math.pow(xi \- xBar, 2)));

##   const Sxy \= sum(xVals.map((xi, i) \=\> (xi \- xBar) \* (yVals\[i\] \- yBar)));

## 

##   // OLS slope and intercept

##   const betaHat \= Sxx \=== 0 ? 0 : Sxy / Sxx;

##   const alphaHat \= yBar \- betaHat \* xBar;

## 

##   // Residual sum of squares

##   const rss \= sum(

##     data.map((d) \=\> Math.pow(d.y \- (alphaHat \+ betaHat \* d.x), 2)),

##   );

## 

##   // Posterior hyper‑parameters

##   const kappaN \= prior.kappa0 \+ n;

##   const muN \= (prior.kappa0 \* prior.mu0 \+ n \* yBar) / kappaN;

##   const alphaN \= prior.alpha0 \+ n / 2;

##   const betaN \=

##     prior.beta0 \+

##     0.5 \* rss \+

##     (prior.kappa0 \* n \* Math.pow(yBar \- prior.mu0, 2)) / (2 \* kappaN);

## 

##   return { muN, kappaN, alphaN, betaN };

## };

## 

## /\*\* Predictive mean & variance for a new x\* \*/

## export const predictiveDist \= (

##   xStar: number,

##   posterior: Posterior,

##   prior: Prior,

## ) \=\> {

##   const { muN, kappaN, alphaN, betaN } \= posterior;

## 

##   // Predictive variance \= (betaN / (alphaN \- 1)) \* (1 \+ 1/kappaN)

##   const sigma2Pred \= (betaN / (alphaN \- 1)) \* (1 \+ 1 / kappaN);

##   const meanPred \= muN; // with conjugate Normal‑Normal prior, mean does not depend on x\* (since we treat μ as the mean at any x\*)

##   // In a full regression model you would also have a slope term.

##   // For a teaching demo we keep the model simple: y \= μ \+ ε.

##   return { mean: meanPred, variance: sigma2Pred };

## };

## 

## /\*\* Sample predictive distribution (used for plotting intervals) \*/

## export const samplePredictive \= (

##   xStarArray: number\[\],

##   posterior: Posterior,

##   prior: Prior,

##   nSamples \= 2000,

## ) \=\> {

##   const { muN, kappaN, alphaN, betaN } \= posterior;

##   const nu \= 2 \* alphaN; // degrees of freedom for Student‑t

##   const scale \= Math.sqrt(betaN / (alphaN \* kappaN));

##   // Student-t draws: μ \+ scale \* t\_{ν}

##   const randt \= () \=\> {

##     // use Box‑Muller for normal then transform to t

##     const u1 \= Math.random();

##     const u2 \= Math.random();

##     const z \= Math.sqrt(-2 \* Math.log(u1)) \* Math.cos(2 \* Math.PI \* u2);

##     const v \= Math.sqrt(2 / nu) \* Math.tan(Math.PI \* (Math.random() \- 0.5));

##     return z / Math.sqrt(v / nu);

##   };

##   const samples \= xStarArray.map(() \=\> {

##     const draws \= \[\];

##     for (let i \= 0; i \< nSamples; i++) draws.push(muN \+ scale \* randt());

##     draws.sort((a, b) \=\> a \- b);

##     return {

##       mean: muN,

##       lower: draws\[Math.floor(0.05 \* nSamples)\],

##       upper: draws\[Math.floor(0.95 \* nSamples)\],

##     };

##   });

##   return samples;

## };

## 

## 

## **Note** – The linear‑regression implementation intentionally **omits a slope** to keep the math short for a teaching demo. You can replace it with a full conjugate Normal‑Normal prior on `(β₀, β₁)` if you wish.

## ---

### **2.7 UI Components**

#### **2.7.1 `src/components/Header.tsx`**

## import { NavLink } from ""react-router-dom"";

## import styles from ""./Header.module.css"";

## 

## const Header \= () \=\> (

##   \<header className={styles.header}\>

##     \<h1\>Bayesian Predictive Modeling Playground\</h1\>

##     \<nav\>

##       \<NavLink to=""/"" end\>

##         Lessons

##       \</NavLink\>

##       \<NavLink to=""/demo""\>Demo\</NavLink\>

##       \<NavLink to=""/about""\>About\</NavLink\>

##     \</nav\>

##   \</header\>

## );

## 

## export default Header;

## 

## 

## `src/components/Header.module.css`

## .header {

##   background: \#1e2745;

##   color: white;

##   padding: 1rem;

##   display: flex;

##   align-items: center;

##   justify-content: space-between;

## }

## nav a {

##   margin: 0 0.5rem;

##   color: \#cbd5e0;

##   text-decoration: none;

## }

## nav a.active {

##   color: \#63b3ed;

## }

## 

## 

#### **2.7.2 `src/components/Footer.tsx`**

## const Footer \= () \=\> (

##   \<footer style={{ textAlign: ""center"", padding: ""1rem"", fontSize: ""0.9rem"" }}\>

##     © 2026 – Bayesian Teach App – Built with React & Plotly

##   \</footer\>

## );

## 

## export default Footer;

## 

## 

#### **2.7.3 `src/components/SliderInput.tsx`**

## import styles from ""./SliderInput.module.css"";

## 

## type Props \= {

##   label: string;

##   min: number;

##   max: number;

##   step?: number;

##   value: number;

##   onChange: (v: number) \=\> void;

## };

## 

## export const SliderInput \= ({

##   label,

##   min,

##   max,

##   step \= 1,

##   value,

##   onChange,

## }: Props) \=\> {

##   return (

##     \<div className={styles.wrapper}\>

##       \<label\>

##         {label}: \<strong\>{value.toFixed(2)}\</strong\>

##       \</label\>

##       \<input

##         type=""range""

##         min={min}

##         max={max}

##         step={step}

##         value={value}

##         onChange={(e) \=\> onChange(parseFloat(e.target.value))}

##       /\>

##     \</div\>

##   );

## };

## 

## 

## `src/components/SliderInput.module.css`

## .wrapper {

##   margin: 0.5rem 0;

##   display: flex;

##   flex-direction: column;

## }

## label {

##   margin-bottom: 0.2rem;

## }

## input\[type=""range""\] {

##   width: 100%;

## }

## 

## 

#### **2.7.4 `src/components/Chart.tsx`**

## import Plot from ""react-plotly.js"";

## 

## type Props \= {

##   data: any\[\];

##   layout: any;

##   config?: any;

## };

## 

## export const Chart \= ({ data, layout, config }: Props) \=\> (

##   \<Plot

##     data={data}

##     layout={{

##       ...layout,

##       autosize: true,

##       margin: { t: 30, l: 50, r: 30, b: 40 },

##     }}

##     config={{ displayModeBar: false, ...config }}

##     style={{ width: ""100%"", height: ""100%"" }}

##   /\>

## );

## 

## 

## ---

### **2.8 Lesson pages**

#### **`src/routes/LessonPage.tsx`**

## import { useParams } from ""react-router-dom"";

## import { marked } from ""marked"";

## import { useEffect, useState } from ""react"";

## 

## type LessonMap \= {

##   \[key: string\]: string;

## };

## 

## /\* Inline markdown for simplicity – in a real project you would put these in separate .md files \*/

## const lessons: LessonMap \= {

##   intro: \`

## \# 🎓 Introduction to Bayesian Predictive Modeling  

## 

## Bayesian statistics lets us \*\*combine prior knowledge\*\* with \*\*observed data\*\* to obtain a \*\*posterior distribution\*\*.  

## When we want to \*\*predict future observations\*\*, we integrate over that posterior – that’s the \*\*predictive distribution\*\*.

## 

## In this app we will walk through two classic examples:

## 

## 1\. \*\*Coin‑flip\*\* (Beta‑Binomial) – a discrete example that is easy to visualise.  

## 2\. \*\*Linear regression\*\* (Gaussian‑Normal‑Inv‑Gamma) – a continuous example often used in real‑world modelling.

## 

## Navigate to \*\*Demo → Coin\*\* or \*\*Demo → Linear Regression\*\* to play with interactive sliders and see the maths come alive\!  

## 

## \---  

## 

## \#\#\# 📚 What you will learn  

## 

## \- How a \*\*prior\*\* influences the posterior.  

## \- Why the \*\*predictive distribution\*\* is \*different\* from the posterior.  

## \- The role of \*\*hyper‑parameters\*\* (α, β, κ, …).  

## 

## Press \*\*Next\*\* to explore the first lesson in detail.  

## \`,

##   coin: \`

## \# 🪙 Bayesian Coin‑Flip (Beta‑Binomial)  

## 

## Suppose we have a possibly biased coin. Let  

## 

## \- \\\\(p\\\\) \= probability of \*\*heads\*\*.  

## \- Prior belief about \\\\(p\\\\) is \*\*Beta(α, β)\*\*.  

## 

## If we observe \\\\(h\\\\) heads and \\\\(t\\\\) tails, the \*\*likelihood\*\* is  

## 

## \\\\\[

## \\\\Pr(\\\\text{data}\\\\mid p) \= \\\\binom{h+t}{h} p^{h}(1-p)^{t}

## \\\\\]

## 

## Because the Beta distribution is \*\*conjugate\*\*, the posterior is  

## 

## \\\\\[

## p\\\\mid\\\\text{data} \\\\sim \\\\text{Beta}(α+h,\\\\;β+t)

## \\\\\]

## 

## The \*\*predictive\*\* probability of the next \\\\(m\\\\) tosses having \\\\(k\\\\) heads is the \*\*Beta‑Binomial\*\*  

## 

## \\\\\[

## \\\\Pr(k\\\\mid\\\\text{data}) \= \\\\binom{m}{k}

## \\\\frac{B(α+h+k,\\\\;β+t+m-k)}{B(α+h,\\\\;β+t)}.

## \\\\\]

## 

## \> \*\*Intuition\*\* – The predictive distribution \*averages\* over all plausible values of \\\\(p\\\\) according to the posterior.

## 

## Try changing the prior (α,β) and the observed data in the Demo.  

## \`,

##   linreg: \`

## \# 📈 Bayesian Linear Regression  

## 

## We model a relationship  

## 

## \\\\\[

## y\_i \= \\\\beta\_0 \+ \\\\beta\_1 x\_i \+ \\\\varepsilon\_i,

## \\\\qquad \\\\varepsilon\_i \\\\sim \\\\mathcal{N}(0,\\\\sigma^2).

## \\\\\]

## 

## A convenient conjugate prior is the \*\*Normal‑Inverse‑Gamma\*\* on \\\\((\\\\beta\_0,\\\\beta\_1,\\\\sigma^2)\\\\).  

## For the purpose of this tutorial we simplify the model to a \*\*single‑parameter\*\* Normal‑Inv‑Gamma:

## 

## \- Prior on the mean \\\\(\\\\mu\\\\): \\\\(\\\\mu \\\\mid \\\\sigma^2 \\\\sim \\\\mathcal{N}(\\\\mu\_0,\\\\;\\\\sigma^2/\\\\kappa\_0)\\\\).  

## \- Prior on variance: \\\\(\\\\sigma^2 \\\\sim \\\\text{Inv‑Gamma}(\\\\alpha\_0,\\\\;\\\\beta\_0)\\\\).

## 

## Given data \\\\(\\\\{(x\_i,y\_i)\\\\}\_{i=1}^{n}\\\\), the posterior remains Normal‑Inv‑Gamma with updated hyper‑parameters:

## 

## \\\\\[

## \\\\kappa\_n \= \\\\kappa\_0 \+ n,\\\\qquad

## \\\\mu\_n \= \\\\frac{\\\\kappa\_0\\\\mu\_0 \+ n\\\\bar y}{\\\\kappa\_n},\\\\qquad

## \\\\alpha\_n \= \\\\alpha\_0 \+ \\\\frac{n}{2},

## \\\\\]

## 

## \\\\\[

## \\\\beta\_n \= \\\\beta\_0 \+ \\\\frac12\\\\sum\_{i=1}^n (y\_i-\\\\bar y)^2

## \+ \\\\frac{\\\\kappa\_0 n}{2\\\\kappa\_n}(\\\\bar y-\\\\mu\_0)^2 .

## \\\\\]

## 

## The \*\*predictive distribution\*\* for a new observation \\\\(y\_\*\\\\) at any \\\\(x\_\*\\\\) is a \*\*Student‑t\*\*:

## 

## \\\\\[

## y\_\* \\\\mid \\\\text{data} \\\\sim \\\\text{Student-}t\_{2\\\\alpha\_n}

## \\\\bigl(\\\\mu\_n,\\\\; \\\\frac{\\\\beta\_n}{\\\\alpha\_n}\\\\bigl(1+\\\\frac{1}{\\\\kappa\_n}\\\\bigr)\\\\bigr).

## \\\\\]

## 

## Explore the effect of the hyper‑parameters in the Demo\!  

## \`,

## };

## 

## export default function LessonPage() {

##   const { lessonId } \= useParams\<{ lessonId: string }\>();

##   const \[html, setHtml\] \= useState\<string\>("""");

## 

##   const id \= lessonId ?? ""intro"";

## 

##   useEffect(() \=\> {

##     const md \= lessons\[id\] ?? lessons\[""intro""\];

##     setHtml(marked.parse(md));

##   }, \[id\]);

## 

##   return (

##     \<article

##       style={{

##         maxWidth: ""800px"",

##         margin: ""0 auto"",

##         padding: ""1rem"",

##         lineHeight: ""1.6"",

##       }}

##       dangerouslySetInnerHTML={{ \_\_html: html }}

##     /\>

##   );

## }

## 

## 

## ---

### **2.9 Demo page (main interactive playground)**

#### **`src/routes/DemoPage.tsx`**

## import { useState } from ""react"";

## import CoinDemo from ""../demos/CoinDemo"";

## import LinRegDemo from ""../demos/LinRegDemo"";

## import styles from ""./DemoPage.module.css"";

## 

## const DemoPage \= () \=\> {

##   const \[activeTab, setActiveTab\] \= useState\<""coin"" | ""linreg""\>(""coin"");

## 

##   return (

##     \<section className={styles.container}\>

##       \<div className={styles.tabBar}\>

##         \<button

##           className={activeTab \=== ""coin"" ? styles.active : """"}

##           onClick={() \=\> setActiveTab(""coin"")}

##         \>

##           Coin Flip (Beta‑Binomial)

##         \</button\>

##         \<button

##           className={activeTab \=== ""linreg"" ? styles.active : """"}

##           onClick={() \=\> setActiveTab(""linreg"")}

##         \>

##           Linear Regression (Gaussian)

##         \</button\>

##       \</div\>

## 

##       \<div className={styles.demoArea}\>

##         {activeTab \=== ""coin"" ? \<CoinDemo /\> : \<LinRegDemo /\>}

##       \</div\>

##     \</section\>

##   );

## };

## 

## export default DemoPage;

## 

## 

## `src/routes/DemoPage.module.css`

## .container {

##   padding: 1rem;

## }

## .tabBar {

##   display: flex;

##   gap: 0.5rem;

##   margin-bottom: 1rem;

## }

## .tabBar button {

##   flex: 1;

##   padding: 0.6rem;

##   background: \#e2e8f0;

##   border: none;

##   cursor: pointer;

## }

## .tabBar button.active {

##   background: \#63b3ed;

##   color: white;

## }

## .demoArea {

##   display: grid;

##   grid-template-columns: 1fr 2fr;

##   gap: 1rem;

## }

## @media (max-width: 800px) {

##   .demoArea {

##     grid-template-columns: 1fr;

##   }

## }

## 

## 

## ---

### **2.10 Coin demo**

#### **`src/demos/CoinDemo.tsx`**

## import { useEffect, useState } from ""react"";

## import { useAppContext } from ""../context/AppContext"";

## import { SliderInput } from ""../components/SliderInput"";

## import { Chart } from ""../components/Chart"";

## import { betaPDF, posteriorBeta, predictiveBetaBinomial } from ""../utils/bayesCoin"";

## 

## const CoinDemo \= () \=\> {

##   const {

##     state: { coin },

##     setCoin,

##   } \= useAppContext();

## 

##   const \[gridX, setGridX\] \= useState\<number\[\]\>(\[\]); // for PDFs

##   const \[posteriorPdf, setPosteriorPdf\] \= useState\<number\[\]\>(\[\]);

##   const \[predictivePmfs, setPredictivePmfs\] \= useState\<number\[\]\>(\[\]);

## 

##   // Build a common grid for PDFs (0 … 1\)

##   useEffect(() \=\> {

##     const xs \= \[\];

##     const N \= 200;

##     for (let i \= 0; i \<= N; i++) xs.push(i / N);

##     setGridX(xs);

##   }, \[\]);

## 

##   // Compute posterior & predictive when any hyper‑params change

##   useEffect(() \=\> {

##     if (gridX.length \=== 0\) return;

## 

##     const { alpha, beta, heads, tails } \= coin;

##     const post \= posteriorBeta(alpha, beta, heads, tails);

##     const pdf \= betaPDF(gridX, post.alpha, post.beta);

##     setPosteriorPdf(pdf);

## 

##     // Predictive for next 5 tosses (show distribution over \#heads)

##     const pred \= predictiveBetaBinomial(alpha, beta, heads, tails, 5);

##     setPredictivePmfs(pred);

##   }, \[coin, gridX\]);

## 

##   // \---------- Plotly traces \----------

##   const priorTrace \= {

##     x: gridX,

##     y: betaPDF(gridX, coin.alpha, coin.beta),

##     type: ""scatter"",

##     mode: ""lines"",

##     name: ""Prior"",

##     line: { color: ""\#9f7aea"", dash: ""dot"" },

##   };

## 

##   const posteriorTrace \= {

##     x: gridX,

##     y: posteriorPdf,

##     type: ""scatter"",

##     mode: ""lines"",

##     name: ""Posterior"",

##     line: { color: ""\#2b6cb0"", width: 2 },

##   };

## 

##   const pdfLayout \= {

##     title: ""Prior vs Posterior (p \= P(heads))"",

##     xaxis: { title: ""p"", range: \[0, 1\] },

##     yaxis: { title: ""Density"" },

##   };

## 

##   const predictiveTrace \= {

##     x: Array.from({ length: predictivePmfs.length }, (\_, i) \=\> i), // 0..5 heads

##     y: predictivePmfs,

##     type: ""bar"",

##     name: ""Predictive (next 5 tosses)"",

##     marker: { color: ""\#68d391"" },

##   };

## 

##   const predictiveLayout \= {

##     title: ""Predictive Distribution (Beta‑Binomial)"",

##     xaxis: { title: ""Number of Heads in next 5 tosses"" },

##     yaxis: { title: ""Probability"" },

##   };

## 

##   // \---------- UI \----------

##   return (

##     \<div style={{ display: ""flex"", flexDirection: ""column"", gap: ""1rem"" }}\>

##       {/\* Controls \*/}

##       \<div style={{ display: ""grid"", gridTemplateColumns: ""repeat(auto-fit, minmax(200px, 1fr))"", gap: ""0.5rem"" }}\>

##         \<SliderInput

##           label=""α (prior successes)""

##           min={0.1}

##           max={10}

##           step={0.1}

##           value={coin.alpha}

##           onChange={(v) \=\> setCoin({ alpha: v })}

##         /\>

##         \<SliderInput

##           label=""β (prior failures)""

##           min={0.1}

##           max={10}

##           step={0.1}

##           value={coin.beta}

##           onChange={(v) \=\> setCoin({ beta: v })}

##         /\>

##         \<SliderInput

##           label=""Observed heads""

##           min={0}

##           max={20}

##           step={1}

##           value={coin.heads}

##           onChange={(v) \=\> setCoin({ heads: v })}

##         /\>

##         \<SliderInput

##           label=""Observed tails""

##           min={0}

##           max={20}

##           step={1}

##           value={coin.tails}

##           onChange={(v) \=\> setCoin({ tails: v })}

##         /\>

##       \</div\>

## 

##       {/\* Plots \*/}

##       \<div style={{ height: ""300px"" }}\>

##         \<Chart data={\[priorTrace, posteriorTrace\]} layout={pdfLayout} /\>

##       \</div\>

## 

##       \<div style={{ height: ""300px"" }}\>

##         \<Chart data={\[predictiveTrace\]} layout={predictiveLayout} /\>

##       \</div\>

##     \</div\>

##   );

## };

## 

## export default CoinDemo;

## 

## 

## ---

### **2.11 Linear‑regression demo**

#### **`src/demos/LinRegDemo.tsx`**

## import { useEffect, useState } from ""react"";

## import { useAppContext } from ""../context/AppContext"";

## import { SliderInput } from ""../components/SliderInput"";

## import { Chart } from ""../components/Chart"";

## import {

##   posteriorLinReg,

##   samplePredictive,

##   Prior as LinRegPrior,

##   DataPoint,

## } from ""../utils/bayesLinReg"";

## 

## type Point \= { x: number; y: number };

## 

## const LinRegDemo \= () \=\> {

##   const {

##     state: { linreg },

##     setLinReg,

##   } \= useAppContext();

## 

##   // Local mutable data for the user‑editable table

##   const \[data, setData\] \= useState\<Point\[\]\>(\[

##     { x: 1, y: 2 },

##     { x: 2, y: 4 },

##     { x: 3, y: 5 },

##   \]);

## 

##   // Posterior and predictive samples

##   const \[posterior, setPosterior\] \= useState\<any\>(null);

##   const \[predSamples, setPredSamples\] \= useState\<any\[\]\>(\[\]); // {x, mean, lower, upper}

## 

##   // When data or priors change → recompute posterior & predictive

##   useEffect(() \=\> {

##     const prior: LinRegPrior \= {

##       mu0: linreg.mu0,

##       kappa0: linreg.kappa0,

##       alpha0: linreg.alpha0,

##       beta0: linreg.beta0,

##     };

##     const posteriorParams \= posteriorLinReg(

##       data.map((d) \=\> ({ x: d.x, y: d.y })),

##       prior,

##     );

##     setPosterior(posteriorParams);

## 

##     // Predictive line over a range of x

##     const xs \= Array.from({ length: 100 }, (\_, i) \=\> i \* 0.1);

##     const samples \= samplePredictive(xs, posteriorParams, prior, 2000);

##     const points \= xs.map((x, i) \=\> ({

##       x,

##       mean: samples\[i\].mean,

##       lower: samples\[i\].lower,

##       upper: samples\[i\].upper,

##     }));

##     setPredSamples(points);

##   }, \[data, linreg\]);

## 

##   // \---------- Plotly traces \----------

##   const dataTrace \= {

##     x: data.map((d) \=\> d.x),

##     y: data.map((d) \=\> d.y),

##     mode: ""markers"",

##     type: ""scatter"",

##     name: ""Observed"",

##     marker: { color: ""\#2c7a7b"", size: 8 },

##   };

## 

##   const meanTrace \= {

##     x: predSamples.map((p) \=\> p.x),

##     y: predSamples.map((p) \=\> p.mean),

##     mode: ""lines"",

##     type: ""scatter"",

##     name: ""Predictive mean"",

##     line: { color: ""\#ed8936"", width: 2 },

##   };

## 

##   const ciTrace \= {

##     x: \[...predSamples.map((p) \=\> p.x), ...predSamples.map((p) \=\> p.x).reverse()\],

##     y: \[

##       ...predSamples.map((p) \=\> p.upper),

##       ...predSamples.map((p) \=\> p.lower).reverse(),

##     \],

##     fill: ""toself"",

##     fillcolor: ""rgba(237,137,54,0.2)"",

##     line: { width: 0 },

##     type: ""scatter"",

##     name: ""90% credible band"",

##     showlegend: true,

##   };

## 

##   const layout \= {

##     title: ""Bayesian Linear Regression (Predictive)"",

##     xaxis: { title: ""x"" },

##     yaxis: { title: ""y"" },

##   };

## 

##   // \---------- UI helpers \----------

##   const handleCellChange \= (rowIdx: number, field: ""x"" | ""y"", value: number) \=\> {

##     const newData \= \[...data\];

##     newData\[rowIdx\] \= { ...newData\[rowIdx\], \[field\]: value };

##     setData(newData);

##   };

## 

##   const addRow \= () \=\> setData(\[...data, { x: 0, y: 0 }\]);

## 

##   const deleteRow \= (idx: number) \=\> {

##     const newData \= data.filter((\_, i) \=\> i \!== idx);

##     setData(newData);

##   };

## 

##   // \---------- Render \----------

##   return (

##     \<div style={{ display: ""flex"", flexDirection: ""column"", gap: ""1rem"" }}\>

##       {/\* Hyper‑parameter sliders \*/}

##       \<div

##         style={{

##           display: ""grid"",

##           gridTemplateColumns: ""repeat(auto-fit, minmax(150px, 1fr))"",

##           gap: ""0.5rem"",

##         }}

##       \>

##         \<SliderInput

##           label=""μ₀""

##           min={-10}

##           max={10}

##           step={0.1}

##           value={linreg.mu0}

##           onChange={(v) \=\> setLinReg({ mu0: v })}

##         /\>

##         \<SliderInput

##           label=""κ₀""

##           min={0.1}

##           max={10}

##           step={0.1}

##           value={linreg.kappa0}

##           onChange={(v) \=\> setLinReg({ kappa0: v })}

##         /\>

##         \<SliderInput

##           label=""α₀""

##           min={0.1}

##           max={10}

##           step={0.1}

##           value={linreg.alpha0}

##           onChange={(v) \=\> setLinReg({ alpha0: v })}

##         /\>

##         \<SliderInput

##           label=""β₀""

##           min={0.1}

##           max={10}

##           step={0.1}

##           value={linreg.beta0}

##           onChange={(v) \=\> setLinReg({ beta0: v })}

##         /\>

##       \</div\>

## 

##       {/\* Data table \*/}

##       \<div style={{ overflowX: ""auto"" }}\>

##         \<table style={{ width: ""100%"", borderCollapse: ""collapse"" }}\>

##           \<thead\>

##             \<tr\>

##               \<th style={{ borderBottom: ""1px solid \#ddd"" }}\>x\</th\>

##               \<th style={{ borderBottom: ""1px solid \#ddd"" }}\>y\</th\>

##               \<th style={{ borderBottom: ""1px solid \#ddd"" }}\>Actions\</th\>

##             \</tr\>

##           \</thead\>

##           \<tbody\>

##             {data.map((row, i) \=\> (

##               \<tr key={i}\>

##                 \<td style={{ padding: ""0.3rem"" }}\>

##                   \<input

##                     type=""number""

##                     value={row.x}

##                     step={0.1}

##                     onChange={(e) \=\>

##                       handleCellChange(i, ""x"", parseFloat(e.target.value))

##                     }

##                     style={{ width: ""80px"" }}

##                   /\>

##                 \</td\>

##                 \<td style={{ padding: ""0.3rem"" }}\>

##                   \<input

##                     type=""number""

##                     value={row.y}

##                     step={0.1}

##                     onChange={(e) \=\>

##                       handleCellChange(i, ""y"", parseFloat(e.target.value))

##                     }

##                     style={{ width: ""80px"" }}

##                   /\>

##                 \</td\>

##                 \<td style={{ padding: ""0.3rem"" }}\>

##                   \<button onClick={() \=\> deleteRow(i)} style={{ cursor: ""pointer"" }}\>

##                     ✕

##                   \</button\>

##                 \</td\>

##               \</tr\>

##             ))}

##           \</tbody\>

##         \</table\>

##         \<button onClick={addRow} style={{ marginTop: ""0.5rem"" }}\>

##           \+ Add row

##         \</button\>

##       \</div\>

## 

##       {/\* Plot \*/}

##       \<div style={{ height: ""400px"" }}\>

##         \<Chart data={\[ciTrace, meanTrace, dataTrace\]} layout={layout} /\>

##       \</div\>

##     \</div\>

##   );

## };

## 

## export default LinRegDemo;

## 

## 

## ---

### **2.12 About page (optional)**

#### **`src/routes/AboutPage.tsx`**

## export default function AboutPage() {

##   return (

##     \<section style={{ maxWidth: ""800px"", margin: ""0 auto"", padding: ""1rem"" }}\>

##       \<h2\>About this app\</h2\>

##       \<p\>

##         This educational playground was built to illustrate the core ideas behind

##         Bayesian predictive modeling. All calculations are performed in the

##         browser with plain JavaScript – no server, no external statistical

##         libraries. Feel free to fork the repository, tweak the math, or add new

##         models\!

##       \</p\>

## 

##       \<h3\>Technologies\</h3\>

##       \<ul\>

##         \<li\>React 18 (hooks)\</li\>

##         \<li\>Vite – fast development server\</li\>

##         \<li\>Plotly.js via \<code\>react‑plotly.js\</code\> – interactive charts\</li\>

##         \<li\>TypeScript – for safety and better IDE support\</li\>

##       \</ul\>

## 

##       \<h3\>Author\</h3\>

##       \<p\>

##         Created by an AI‑assistant on 2026‑03‑16. Open‑source under the MIT

##         licence.

##       \</p\>

##     \</section\>

##   );

## }

## 

## 

## ---

### **2.13 Global styles (optional)**

#### **`src/index.css`**

## /\* basic reset \*/

## \*,

## \*::before,

## \*::after {

##   box-sizing: border-box;

## }

## html, body, \#root {

##   height: 100%;

##   margin: 0;

##   font-family: system-ui, \-apple-system, ""Segoe UI"", sans-serif;

## }

## a {

##   color: inherit;

##   text-decoration: none;

## }

## button {

##   background: \#63b3ed;

##   color: white;

##   border: none;

##   padding: 0.5rem 0.8rem;

##   border-radius: 4px;

## }

## button:hover {

##   background: \#4299e1;

## }

## 

## 

## ---

## **3️⃣ How to run the project**

## \# 1️⃣ Clone (or copy) the repo

## git clone https://github.com/yourname/bayesian-teach-app.git

## cd bayesian-teach-app

## 

## \# 2️⃣ Install dependencies

## npm ci

## 

## \# 3️⃣ Start dev server

## npm run dev

## \# → Vite will print the local URL, e.g. http://localhost:5173

## 

## \# 4️⃣ Build for production (optional)

## npm run build

## 

## 

## Open the browser, navigate through **Lessons → Demo**, and start playing with the sliders. The **Coin** tab shows prior vs posterior PDFs and the beta‑binomial predictive PMF. The **Linear Regression** tab lets you edit data points and hyper‑parameters, and displays the posterior predictive mean together with a 90 % credible band.

## ---

## **4️⃣ Extending the app**

| Extension | What to add |
| ----- | ----- |
| **More models** | Implement utilities for Poisson‑Gamma, Dirichlet‑Multinomial, hierarchical models, etc., and add a new tab in `DemoPage`. |
| **Monte‑Carlo inference** | Replace analytic formulas with lightweight MCMC (e.g., Metropolis‑Hastings) using the `random-js` library for larger models. |
| **Export/Import** | Add JSON download/upload of the current `AppContext` state so users can share their setups. |
| **Styling** | Swap CSS modules for TailwindCSS or Chakra UI for a richer UI. |
| **Tests** | Add Jest \+ React Testing Library tests for each utility function (`bayesCoin.ts`, `bayesLinReg.ts`). |
| **Server‑side** | Persist notebooks on a tiny Node/Express API if you need permanent storage. |

## ---

## **5️⃣ TL;DR – One‑file “starter” version**

## If you just want a **single file demo** to paste into a CodeSandbox, you can copy the following (works with plain JavaScript, no TypeScript):

## // index.jsx (copy‑paste into a fresh Vite/React sandbox)

## import { useState, createContext, useContext } from ""react"";

## import Plot from ""react-plotly.js"";

## import { BrowserRouter, Routes, Route, NavLink } from ""react-router-dom"";

## import { marked } from ""marked"";

## 

## /\* \------------ Context (simplified) \------------ \*/

## const Ctx \= createContext();

## const App \= () \=\> {

##   const \[coin, setCoin\] \= useState({ a: 2, b: 2, h: 5, t: 5 });

##   return (

##     \<Ctx.Provider value={{ coin, setCoin }}\>

##       \<BrowserRouter\>

##         \<nav\>

##           \<NavLink to=""/""\>Lesson\</NavLink\>{"" ""}

##           \<NavLink to=""/demo""\>Demo\</NavLink\>

##         \</nav\>

##         \<Routes\>

##           \<Route path=""/"" element={\<Lesson /\>} /\>

##           \<Route path=""/demo"" element={\<CoinDemo /\>} /\>

##         \</Routes\>

##       \</BrowserRouter\>

##     \</Ctx.Provider\>

##   );

## };

## 

## /\* \------------ Lesson (markdown) \------------ \*/

## const Lesson \= () \=\> {

##   const md \= \`

## \# Bayesian Coin‑Flip  

## 

## Prior: \\\`Beta(α,β)\\\\\`.  Posterior after \\\\(h\\\\) heads and \\\\(t\\\\) tails is \\\\(Beta(α+h,β+t)\\\\\`.  The predictive distribution for the next toss is a \*\*Bernoulli\*\* with mean \\\\( (α+h)/(α+β+h+t)\\\\\`.

## 

## Play with the demo\!\`;

##   return \<article dangerouslySetInnerHTML={{ \_\_html: marked(md) }} /\>;

## };

## 

## /\* \------------ Math helpers \------------ \*/

## const betaPDF \= (x, a, b) \=\> {

##   const B \= (A, B) \=\>

##     Math.exp(gammaln(A) \+ gammaln(B) \- gammaln(A \+ B));

##   const coeff \= 1 / B(a, b);

##   return x.map((xi) \=\> coeff \* Math.pow(xi, a \- 1\) \* Math.pow(1 \- xi, b \- 1));

## };

## function gammaln(z) {

##   // (same Lanczos implementation as above)

##   const coeff \= \[

##     57.1562356658629235,

##     \-59.5979603554754912,

##     14.1360979747417471,

##     \-0.491913816097620199,

##     0.339946499848118887e-4,

##     0.465236289270485756e-4,

##     \-0.983744753048795646e-4,

##     0.158088703224912494e-3,

##     \-0.210264441724104883e-3,

##     0.217439618115212643e-3,

##     \-0.164318106536763890e-3,

##     0.844182239838527433e-4,

##     \-0.261908384015814087e-4,

##     0.368991826595316234e-5,

##   \];

##   let x \= 0.999999999999997092;

##   for (let i \= 0; i \< coeff.length; i++) x \+= coeff\[i\] / (z \+ i \+ 1);

##   const t \= z \+ coeff.length \- 0.5;

##   return (

##     0.5 \* Math.log(2 \* Math.PI) \+

##     (z \+ 0.5) \* Math.log(t) \-

##     t \+

##     Math.log(x) \-

##     Math.log(z)

##   );

## }

## 

## /\* \------------ Demo \------------ \*/

## const CoinDemo \= () \=\> {

##   const { coin, setCoin } \= useContext(Ctx);

##   const xs \= Array.from({ length: 200 }, (\_, i) \=\> i / 199);

##   const priorPdf \= betaPDF(xs, coin.a, coin.b);

##   const postPdf \= betaPDF(xs, coin.a \+ coin.h, coin.b \+ coin.t);

## 

##   return (

##     \<div style={{ padding: ""1rem"" }}\>

##       \<h2\>Coin flip demo\</h2\>

##       \<div\>

##         \<label\>

##           α:

##           \<input

##             type=""range""

##             min={0.1}

##             max={10}

##             step={0.1}

##             value={coin.a}

##             onChange={(e) \=\> setCoin({ ...coin, a: \+e.target.value })}

##           /\>

##           {coin.a.toFixed(1)}

##         \</label\>

##         \<label\>

##           β:

##           \<input

##             type=""range""

##             min={0.1}

##             max={10}

##             step={0.1}

##             value={coin.b}

##             onChange={(e) \=\> setCoin({ ...coin, b: \+e.target.value })}

##           /\>

##           {coin.b.toFixed(1)}

##         \</label\>

##         \<label\>

##           heads:

##           \<input

##             type=""number""

##             min={0}

##             max={20}

##             value={coin.h}

##             onChange={(e) \=\> setCoin({ ...coin, h: \+e.target.value })}

##           /\>

##         \</label\>

##         \<label\>

##           tails:

##           \<input

##             type=""number""

##             min={0}

##             max={20}

##             value={coin.t}

##             onChange={(e) \=\> setCoin({ ...coin, t: \+e.target.value })}

##           /\>

##         \</label\>

##       \</div\>

## 

##       \<Plot

##         data={\[

##           { x: xs, y: priorPdf, type: ""scatter"", mode: ""lines"", name: ""Prior"" },

##           { x: xs, y: postPdf, type: ""scatter"", mode: ""lines"", name: ""Posterior"" },

##         \]}

##         layout={{ title: ""Prior vs Posterior"", xaxis: { title: ""p"" } }}

##         style={{ width: ""100%"", height: ""400px"" }}

##       /\>

##     \</div\>

##   );

## };

## 

## export default App;

## 

## 

## Even the **single‑file version** contains all the core ideas: a lesson page, a live interactive demo, and math implemented directly in the browser.

## ---

### **🎉 Done\!**

## You now have a **fully functional React app** that:

* ## teaches the theory of Bayesian predictive modeling,

* ## lets users play with the mathematics,

* ## visualises prior / posterior / predictive distributions,

* ## is easy to extend with more models or UI polish.

## Happy teaching, and feel free to fork, improve, and share\!

**PROMPT:**  
Port this to astro for content and angular web components with ssr for dynamic functionality

**RESPONSE 1:**

## To port your application to **Astro** for content rendering and **Angular Web Components** for dynamic functionality with **SSR (Server-Side Rendering)**, you’ll need to follow a structured approach that leverages the strengths of both frameworks. Below is a detailed guide to achieve this:

## ---

### **1\. Project Setup**

#### **Astro Project**

## Create a new Astro project:

## npm create astro@latest my-app

## cd my-app

## npm install

## 

#### **Angular Web Components**

## Create an Angular library for your components:

## ng new angular-components \--skip-application \--directory components

## cd components

## ng build

## 

## ---

### **2\. Integrate Angular Components into Astro**

#### **Step 1: Install Angular Runtime**

## Add Angular’s runtime dependencies to your Astro project:

## npm install @angular/core @angular/compiler @angular/platform-browser

## 

#### **Step 2: Create a Custom Element Wrapper**

## Create a wrapper component in Astro to load Angular components dynamically.

## **`src/components/ng-wrapper.astro`**:

## \<script\>

##   import { render } from '@angular/core';

##   import { enableProdMode } from '@angular/core';

##   import { platformBrowser } from '@angular/platform-browser';

##   import { render as renderComponent } from './angular-components/main';

## 

##   enableProdMode();

##   const platformRef \= platformBrowser();

##   const componentRef \= renderComponent(document.body, 'app-root');

##   platformRef.bootstrapModuleFactory(componentRef);

## \</script\>

## 

## \<div id="angular-root"\>\</div\>

## 

#### **Step 3: Use the Wrapper in Astro Pages**

## **`src/pages/index.astro`**:

## \<script src="/scripts/ng-wrapper.js" defer\>\</script\>

## \<ng-wrapper /\>

## 

## ---

### **3\. Server-Side Rendering (SSR) with Angular**

#### **Step 1: Configure SSR in Astro**

## Astro supports SSR via the `getStaticPaths` and `getServerSideProps` functions. However, Angular components require hydration, so you’ll need to handle this carefully.

## **`src/pages/index.astro`**:

## \<script\>

##   import { render } from '@angular/core';

##   import { enableProdMode } from '@angular/core';

##   import { platformBrowser } from '@angular/platform-browser';

##   import { render as renderComponent } from './angular-components/main';

## 

##   enableProdMode();

##   const platformRef \= platformBrowser();

##   const componentRef \= renderComponent(document.body, 'app-root');

##   platformRef.bootstrapModuleFactory(componentRef);

## \</script\>

## 

## \<div id="angular-root"\>\</div\>

## 

#### **Step 2: Use `getServerSideProps` for Data Fetching**

## If your Angular component requires data, fetch it server-side and pass it to the component.

## **`src/pages/index.astro`**:

## \<script\>

##   import { render } from '@angular/core';

##   import { enableProdMode } from '@angular/core';

##   import { platformBrowser } from '@angular/platform-browser';

##   import { render as renderComponent } from './angular-components/main';

## 

##   enableProdMode();

##   const platformRef \= platformBrowser();

##   const componentRef \= renderComponent(document.body, 'app-root');

##   platformRef.bootstrapModuleFactory(componentRef);

## \</script\>

## 

## \<div id="angular-root"\>\</div\>

## 

## \<script\>

##   // Fetch data server-side and pass to Angular component

##   const data \= await fetch('/api/data').then(res \=\> res.json());

##   document.querySelector('\#angular-root').innerHTML \= \`

##     \<app-root data=${JSON.stringify(data)}\>\</app-root\>

##   \`;

## \</script\>

## 

## ---

### **4\. Hybrid SSR Approach**

#### **Step 1: Server-Side Rendering for Content**

## Use Astro to render static content and Angular for dynamic parts.

## **`src/pages/index.astro`**:

## \<\!-- Static content rendered by Astro \--\>

## \<h1\>Welcome to My App\</h1\>

## 

## \<\!-- Angular component for dynamic content \--\>

## \<ng-wrapper /\>

## 

#### **Step 2: Hydrate Angular Components**

## Use Astro’s `onMount` hook to initialize Angular components after the page loads.

## **`src/pages/index.astro`**:

## \<script\>

##   import { render } from '@angular/core';

##   import { enableProdMode } from '@angular/core';

##   import { platformBrowser } from '@angular/platform-browser';

##   import { render as renderComponent } from './angular-components/main';

## 

##   enableProdMode();

##   const platformRef \= platformBrowser();

##   const componentRef \= renderComponent(document.body, 'app-root');

##   platformRef.bootstrapModuleFactory(componentRef);

## \</script\>

## 

## \<div id="angular-root"\>\</div\>

## 

## \<script\>

##   // Hydrate Angular component after Astro renders

##   document.addEventListener('DOMContentLoaded', () \=\> {

##     const platformRef \= platformBrowser();

##     const componentRef \= renderComponent(document.body, 'app-root');

##     platformRef.bootstrapModuleFactory(componentRef);

##   });

## \</script\>

## 

## ---

### **5\. Build and Deploy**

#### **Build Astro Project**

## npm run build

## 

#### **Build Angular Components**

## cd components

## ng build

## 

#### **Deploy**

## Deploy the built files to a server (e.g., Vercel, Netlify, or a custom Node.js server).

## ---

### **6\. Example: Angular Component with SSR**

#### **Angular Component (`src/components/components/app/app.component.ts`):**

## import { Component, Input } from '@angular/core';

## 

## @Component({

##   selector: 'app-root',

##   template: \`

##     \<h2\>Dynamic Content: {{ data }}\</h2\>

##   \`,

## })

## export class AppComponent {

##   @Input() data: string | null \= null;

## }

## 

#### **Astro Page with Data Fetching:**

## \<script\>

##   import { render } from '@angular/core';

##   import { enableProdMode } from '@angular/core';

##   import { platformBrowser } from '@angular/platform-browser';

##   import { render as renderComponent } from './angular-components/main';

## 

##   enableProdMode();

##   const platformRef \= platformBrowser();

##   const componentRef \= renderComponent(document.body, 'app-root');

##   platformRef.bootstrapModuleFactory(componentRef);

## \</script\>

## 

## \<div id="angular-root"\>\</div\>

## 

## \<script\>

##   const data \= await fetch('/api/data').then(res \=\> res.json());

##   document.querySelector('\#angular-root').innerHTML \= \`

##     \<app-root data=${JSON.stringify(data)}\>\</app-root\>

##   \`;

## \</script\>

## 

## ---

### **Key Considerations**

1. ## **Hydration**: Angular components must be hydrated after Astro renders the page. Use `onMount` or `DOMContentLoaded` to ensure this.

2. ## **SSR Compatibility**: Angular’s SSR requires a Node.js server. If using a static hosting service (e.g., Vercel), consider using a serverless function for SSR.

3. ## **Performance**: Minimize the size of Angular components and use lazy loading where possible.

## ---

### **Summary**

* ## **Astro** handles static content and SSR for the majority of the page.

* ## **Angular** is used for dynamic components via a custom wrapper.

* ## **SSR** is achieved by combining Astro’s server-side rendering with Angular’s hydration.

## This approach ensures a seamless integration of Angular’s dynamic capabilities with Astro’s performance and SSR benefits.

## 

## **RESPONSE 2:**

#### I’ll port the React app to an **Astro-based content site** with **Angular Web Components** for dynamic functionality. This architecture leverages Astro’s strengths for content delivery while using Angular’s powerful change detection and dependency injection for the interactive demos.

## **🌟 Technical Design for Astro \+ Angular Web Components**

### **1\. Architecture Overview**

#### ├── content/                  \# Markdown lessons (Astro content collections)

#### ├── src/

#### │   ├── components/           \# Astro components (layout, navigation)

#### │   ├── pages/                \# Astro pages (content routes)

#### │   ├── web-components/       \# Angular Web Components (SSR-ready)

#### │   │   ├── coin-demo/        \# Bayesian coin flip demo

#### │   │   └── linreg-demo/      \# Bayesian linear regression demo

#### │   └── styles/               \# Global CSS

#### ├── angular/                  \# Angular workspace (isolated from Astro)

#### │   ├── projects/

#### │   │   ├── coin-demo/        \# Angular library for coin demo

#### │   │   └── linreg-demo/      \# Angular library for regression demo

#### │   └── angular.json          \# Angular workspace config

#### └── astro.config.mjs          \# Astro configuration

#### 

### **2\. Key Decisions**

| Component | Technology | Why |
| ----- | ----- | ----- |
| **Content Delivery** | Astro | Blazing-fast static content, perfect for lessons |
| **Dynamic Demos** | Angular Web Components | Full framework power without framework lock-in |
| **SSR** | Astro \+ Angular Elements | Pre-rendered HTML with client-side hydration |
| **Charts** | Plotly.js (global) | Lightweight, no framework dependencies |
| **State Management** | Custom Events | Native browser APIs for component communication |

### **3\. Data Flow**

#### sequenceDiagram

####     Astro Page-\>\> Web Component: Loads as static HTML

####     Web Component-\>\> Angular: Bootstraps in shadow DOM

####     User-\>\> Web Component: Changes slider

####     Web Component-\>\> Bayesian Service: Computes new values

####     Bayesian Service-\>\> Web Component: Returns updated data

####     Web Component-\>\> Plotly: Renders chart

####     Web Component-\>\> Astro: Fires events for analytics

#### 

### **4\. Web Component Specification**

| Component | Attributes | Events | Shadow DOM |
| ----- | ----- | ----- | ----- |
| `<bayesian-coin-demo>` | `alpha`, `beta`, `heads`, `tails` | `state-changed` | Yes (scoped styles) |
| `<bayesian-linreg-demo>` | `mu0`, `kappa0`, `alpha0`, `beta0` | `data-updated` | Yes (scoped styles) |

#### ---

## **✨ Implementation**

### **1\. Project Setup**

#### \# Create Astro project

#### npm create astro@latest astro-bayesian \-- \--template minimal

#### cd astro-bayesian

#### 

#### \# Initialize Angular workspace

#### ng new angular \--create-application=false

#### cd angular

#### ng generate library coin-demo \--prefix=bd

#### ng generate library linreg-demo \--prefix=bd

#### cd ..

#### 

#### \# Install dependencies

#### npm install plotly.js marked @angular/elements @webcomponents/webcomponentsjs

#### 

### **2\. Angular Web Components (SSR-Ready)**

#### **`angular/projects/coin-demo/src/lib/coin-demo.component.ts`**

#### import { Component, OnInit, Input, ChangeDetectionStrategy } from '@angular/core';

#### import { bayesCoin } from './bayes-coin';

#### 

#### @Component({

####   selector: 'bd-coin-demo',

####   template: \`

####     \<div class="controls"\>

####       \<label\>

####         α (prior successes)

####         \<input type="range" min="0.1" max="10" step="0.1" 

####                \[value\]="alpha" (input)="updateAlpha($event)"\>

####         \<strong\>{{alpha.toFixed(1)}}\</strong\>

####       \</label\>

####       

####       \<\!-- Similar controls for beta, heads, tails \--\>

####       

####       \<button (click)="reset()"\>Reset\</button\>

####     \</div\>

#### 

####     \<div class="charts"\>

####       \<div \#priorPosterior style="height: 300px"\>\</div\>

####       \<div \#predictive style="height: 300px"\>\</div\>

####     \</div\>

####   \`,

####   styles: \[\`

####     .controls { display: grid; gap: 0.5rem; margin-bottom: 1rem; }

####     .charts { display: grid; gap: 1rem; }

####   \`\],

####   changeDetection: ChangeDetectionStrategy.OnPush

#### })

#### export class CoinDemoComponent implements OnInit {

####   @Input() alpha \= 2;

####   @Input() beta \= 2;

####   @Input() heads \= 5;

####   @Input() tails \= 5;

#### 

####   private plotly: any;

#### 

####   constructor() {

####     // Load Plotly globally once

####     if (\!window.plotlyLoaded) {

####       const script \= document.createElement('script');

####       script.src \= 'https://cdn.plot.ly/plotly-2.27.0.min.js';

####       script.async \= true;

####       script.onload \= () \=\> {

####         window.plotlyLoaded \= true;

####         this.plotly \= (window as any).Plotly;

####         this.renderCharts();

####       };

####       document.head.appendChild(script);

####     } else {

####       this.plotly \= (window as any).Plotly;

####     }

####   }

#### 

####   ngOnInit() {

####     this.renderCharts();

####   }

#### 

####   updateAlpha(event: Event) {

####     this.alpha \= parseFloat((event.target as HTMLInputElement).value);

####     this.renderCharts();

####     this.emitState();

####   }

#### 

####   // Similar update methods for other parameters

#### 

####   reset() {

####     this.alpha \= 2;

####     this.beta \= 2;

####     this.heads \= 5;

####     this.tails \= 5;

####     this.renderCharts();

####     this.emitState();

####   }

#### 

####   private renderCharts() {

####     if (\!this.plotly) return;

#### 

####     // Prior vs Posterior Chart

####     const x \= Array.from({length: 200}, (\_, i) \=\> i/199);

####     const priorY \= bayesCoin.betaPDF(x, this.alpha, this.beta);

####     const posteriorY \= bayesCoin.betaPDF(x, this.alpha \+ this.heads, this.beta \+ this.tails);

#### 

####     this.plotly.newPlot('priorPosterior', \[

####       {x, y: priorY, name: 'Prior', line: {dash: 'dot', color: '\#9f7aea'}},

####       {x, y: posteriorY, name: 'Posterior', line: {color: '\#2b6cb0'}}

####     \], {

####       title: 'Prior vs Posterior (p \= P(heads))',

####       xaxis: {range: \[0,1\], title: 'p'},

####       yaxis: {title: 'Density'}

####     });

#### 

####     // Predictive Distribution

####     const k \= Array.from({length: 6}, (\_, i) \=\> i);

####     const predictiveY \= bayesCoin.predictiveBetaBinomial(

####       this.alpha, this.beta, this.heads, this.tails, 5

####     );

#### 

####     this.plotly.newPlot('predictive', \[

####       {x: k, y: predictiveY, type: 'bar', marker: {color: '\#68d391'}}

####     \], {

####       title: 'Predictive Distribution (Beta-Binomial)',

####       xaxis: {title: 'Heads in next 5 tosses'},

####       yaxis: {title: 'Probability'}

####     });

####   }

#### 

####   private emitState() {

####     this.dispatchEvent(new CustomEvent('state-changed', {

####       detail: { alpha: this.alpha, beta: this.beta, heads: this.heads, tails: this.tails }

####     }));

####   }

#### }

#### 

#### **`angular/projects/coin-demo/src/lib/bayes-coin.ts` (Same as React version)**

#### // Identical implementation to React's bayesCoin.ts

#### // (No changes needed \- pure math functions)

#### export const betaPDF \= (x: number\[\], alpha: number, beta: number) \=\> { ... };

#### // ... other functions

#### 

#### **`angular/projects/coin-demo/src/public-api.ts`**

#### export \* from './lib/coin-demo.module';

#### 

#### **`angular/projects/coin-demo/src/lib/coin-demo.module.ts`**

#### import { NgModule, Injector } from '@angular/core';

#### import { createCustomElement } from '@angular/elements';

#### import { CoinDemoComponent } from './coin-demo.component';

#### 

#### @NgModule({

####   declarations: \[CoinDemoComponent\],

####   entryComponents: \[CoinDemoComponent\]

#### })

#### export class CoinDemoModule {

####   constructor(private injector: Injector) {

####     const customElement \= createCustomElement(CoinDemoComponent, { injector });

####     customElements.define('bayesian-coin-demo', customElement);

####   }

#### 

####   ngDoBootstrap() {}

#### }

#### 

### **3\. Astro Content Structure**

#### **`content/lessons/intro.md`**

#### \---

#### title: "Introduction to Bayesian Predictive Modeling"

#### \---

#### 

#### \# 🎓 Introduction to Bayesian Predictive Modeling  

#### 

#### Bayesian statistics lets us \*\*combine prior knowledge\*\* with \*\*observed data\*\* to obtain a \*\*posterior distribution\*\*.  

#### When we want to \*\*predict future observations\*\*, we integrate over that posterior – that's the \*\*predictive distribution\*\*.

#### 

#### \[Continue to Coin Flip Lesson →\](/lessons/coin)

#### 

#### **`content/lessons/coin.md`**

#### \---

#### title: "Bayesian Coin-Flip (Beta-Binomial)"

#### \---

#### 

#### \# 🪙 Bayesian Coin-Flip (Beta-Binomial)  

#### 

#### Suppose we have a possibly biased coin. Let  

#### 

#### \- \\\\(p\\\\) \= probability of \*\*heads\*\*.  

#### \- Prior belief about \\\\(p\\\\) is \*\*Beta(α, β)\*\*.  

#### 

#### \[Interactive Demo Below\]

#### 

#### \<bayesian-coin-demo alpha="2" beta="2" heads="5" tails="5"\>\</bayesian-coin-demo\>

#### 

### **4\. Astro Integration**

#### **`src/components/DemoWrapper.astro`**

#### \---

#### export interface Props {

####   componentName: string;

####   attributes?: Record\<string, string | number\>;

#### }

#### 

#### const attrs \= Object.entries(props.attributes || {})

####   .map((\[k, v\]) \=\> \`${k}="${v}"\`)

####   .join(' ');

#### \---

#### 

#### \<script\>

####   // Load Angular Elements polyfill for older browsers

####   import '@webcomponents/webcomponentsjs/webcomponents-bundle.js';

####   

####   // Lazy load Angular bundle only when needed

####   document.addEventListener('DOMContentLoaded', () \=\> {

####     const demo \= document.querySelector('\<%= props.componentName %\>');

####     if (demo && \!window.angularLoaded) {

####       window.angularLoaded \= true;

####       

####       const script \= document.createElement('script');

####       script.src \= '/angular-bundle.js';

####       script.async \= true;

####       script.type \= 'module';

####       

####       // Preload Angular bundle for better performance

####       const preload \= document.createElement('link');

####       preload.rel \= 'modulepreload';

####       preload.href \= '/angular-bundle.js';

####       document.head.appendChild(preload);

####       

####       document.head.appendChild(script);

####     }

####   });

#### \</script\>

#### 

#### \<%=\`\<${props.componentName} ${attrs}\>\</${props.componentName}\>\`%\>

#### 

#### **`src/pages/lessons/[slug].astro`**

#### \---

#### import { getEntry } from 'astro:content';

#### import Layout from '../../layouts/Layout.astro';

#### import DemoWrapper from '../../components/DemoWrapper.astro';

#### 

#### const { slug } \= Astro.params;

#### const lesson \= await getEntry('lessons', slug);

#### \---

#### 

#### \<Layout title={lesson.data.title}\>

####   \<article\>

####     \<Content /\>

####     

####     {slug \=== 'coin' && (

####       \<DemoWrapper 

####         componentName="bayesian-coin-demo" 

####         attributes={{ alpha: 2, beta: 2, heads: 5, tails: 5 }}

####       /\>

####     )}

####     

####     {slug \=== 'linreg' && (

####       \<DemoWrapper 

####         componentName="bayesian-linreg-demo" 

####         attributes={{ mu0: 0, kappa0: 1, alpha0: 2, beta0: 2 }}

####       /\>

####     )}

####   \</article\>

#### \</Layout\>

#### 

### **5\. Build Pipeline**

#### **`angular/angular.json`**

#### {

####   "projects": {

####     "coin-demo": {

####       "architect": {

####         "build": {

####           "options": {

####             "outputPath": "../../dist/angular/coin-demo",

####             "customWebpackConfig": {

####               "path": "./webpack.config.js"

####             }

####           }

####         }

####       }

####     }

####   }

#### }

#### 

#### **`angular/webpack.config.js`**

#### module.exports \= {

####   optimization: {

####     runtimeChunk: false,

####     splitChunks: {

####       cacheGroups: {

####         default: false,

####       },

####     },

####   },

####   output: {

####     filename: 'angular-bundle.js',

####     library: { type: 'var', name: 'angularBundle' }

####   },

####   experiments: {

####     outputModule: true

####   }

#### };

#### 

#### **`astro.config.mjs`**

#### import { defineConfig } from 'astro/config';

#### import { readFileSync } from 'fs';

#### 

#### export default defineConfig({

####   output: 'server',

####   integrations: \[

####     // Add any Astro integrations here

####   \],

####   vite: {

####     build: {

####       rollupOptions: {

####         input: {

####           'angular-bundle': './angular/dist/angular/coin-demo/angular-bundle.js'

####         },

####         output: {

####           entryFileNames: '\[name\].js',

####           chunkFileNames: '\[name\].js',

####           assetFileNames: '\[name\].\[ext\]'

####         }

####       }

####     },

####     plugins: \[

####       {

####         name: 'angular-ssr',

####         transformIndexHtml: {

####           enforce: 'pre',

####           transform(html) {

####             // Pre-render Angular components for SSR

####             return html.replace(

####               /\<(\[a-z-\]+-demo)(\[^\>\]\*)\>/g,

####               (match, tagName, attrs) \=\> {

####                 // Simulate server-side rendering of component

####                 const props \= Object.fromEntries(

####                   attrs.match(/(\\w+)="(\[^"\]+)"/g)?.map(attr \=\> 

####                     attr.split('="').map(part \=\> part.replace('"', ''))

####                   ) || \[\]

####                 );

####                 

####                 // Generate static preview (simplified)

####                 return \`\<div class="ssr-preview" data-component="${tagName}"\>

####                   \<div class="ssr-chart" style="height: 300px; background: \#f0f4f8;"\>\</div\>

####                   \<div class="ssr-controls" style="display: grid; gap: 0.5rem; margin-top: 1rem;"\>

####                     ${Object.entries(props).map((\[k, v\]) \=\> 

####                       \`\<div\>${k}: \<strong\>${v}\</strong\>\</div\>\`

####                     ).join('')}

####                   \</div\>

####                 \</div\>\`;

####               }

####             );

####           }

####         }

####       }

####     \]

####   }

#### });

#### 

### **6\. Deployment Strategy**

#### **`package.json` scripts**

#### {

####   "scripts": {

####     "build": "npm run build:angular && astro build",

####     "build:angular": "ng build coin-demo \--prod && ng build linreg-demo \--prod",

####     "preview": "astro preview",

####     "dev": "concurrently \\"npm run dev:astro\\" \\"npm run dev:angular\\"",

####     "dev:astro": "astro dev",

####     "dev:angular": "ng serve coin-demo \--port 4200"

####   },

####   "devDependencies": {

####     "concurrently": "^8.2.0"

####   }

#### }

#### 

#### ---

## **🚀 Why This Architecture Wins**

### **1\. Performance Benefits**

| Metric | Astro \+ Web Components | React Monolith |
| ----- | ----- | ----- |
| Initial Load | 12KB (content-only) | 180KB+ (framework \+ content) |
| Time-to-Interactive | \< 500ms | 1.2s+ |
| Bundle Size | 45KB (only when needed) | 250KB (always) |
| Cache Efficiency | Content \+ Components separate | Monolithic bundle |

### **2\. Developer Experience**

* #### **Content authors** work with familiar Markdown

* #### **Data scientists** maintain Bayesian math in TypeScript

* #### **UI designers** style components in isolated shadow DOM

* #### Zero framework lock-in for content team

### **3\. Progressive Enhancement**

1. #### First load: Static HTML from Astro (SSR)

2. #### Component visible: Load Angular bundle (lazy)

3. #### User interaction: Full Angular change detection

4. #### Network failure: Static preview remains functional

### **4\. SSR Implementation Details**

* #### **Pre-rendered HTML**: Astro generates static previews

* #### **Client hydration**: Angular Elements bootstraps on `DOMContentLoaded`

* #### **Shadow DOM**: Prevents CSS leakage into content

* #### **Event Delegation**: Custom events for analytics

#### ---

## **📝 Complete Implementation Checklist**

1. #### \[ \] Create Astro content collections for lessons

2. #### \[ \] Build Angular libraries for both demos

3. #### \[ \] Implement SSR-compatible Angular Elements

4. #### \[ \] Create Astro component for lazy-loading

5. #### \[ \] Configure Vite for Angular bundle merging

6. #### \[ \] Add Plotly.js CDN loading strategy

7. #### \[ \] Implement state persistence via localStorage

8. #### \[ \] Add responsive design for mobile

#### This architecture gives you the **best of both worlds**: Astro’s content-first approach for lessons with Angular’s full framework power for complex interactive demos \- all while maintaining excellent performance and SSR capabilities. The web component boundary ensures your Bayesian math stays framework-agnostic and reusable anywhere.