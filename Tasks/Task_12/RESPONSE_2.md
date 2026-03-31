# Response 2

## **Changing the colour of an SVG `<text>` element**

In SVG the visual colour of a `<text>` node is controlled by the **`fill`** (for the interior of the glyphs) and **`stroke`** (for an outline) properties.
You can set those properties in three mainstream ways:

| How you set it | What you write | When it's useful |
| ----- | ----- | ----- |
| **CSS** (external, `<style>`, or inline `style=`) | `fill: red;` (or `stroke: blue;`) | Keep styling separate from markup, make colour switchable with classes or media‑queries. |
| **SVG attribute** (`fill=`) | `<text fill="red">…</text>` | Quick one‑off change; works even when CSS is disabled. |
| **JavaScript** (`setAttribute`, `style.fill`, or `textElement.textContent = …`) | `textEl.setAttribute('fill', '#0a7');` | Dynamic colour changes at runtime (e.g., on hover, in response to data). |

Below you'll find a **complete, step‑by‑step guide** that shows each method, discusses pitfalls, and gives a few advanced tricks (CSS variables, `currentColor`, multiple `<tspan>`s, animations).

---

## **1️⃣ Basic HTML / SVG Boilerplate**

<!DOCTYPE html>

<html lang="en">

<head>

  <meta charset="UTF-8">

  <title>SVG Text Colour Demo</title>

  <style>

    /* You'll see how to override these later */

    .red   { fill: red;   }

    .green { fill: green; }

    .blue  { fill: blue;  }

  </style>

</head>

<body>

<svg id="demoSvg"

     width="400" height="120"

     viewBox="0 0 400 120"

     xmlns="http://www.w3.org/2000/svg">

  <!-- Plain text, no styling yet -->

  <text id="myText"

        x="20" y="60"

        font-family="Arial,Helvetica,sans-serif"

        font-size="40">

    Hello SVG!

  </text>

</svg>

<script src="demo.js"></script>

</body>

</html>

Everything that follows can be applied to the `<text>` element with `id="myText"` (or any other `<text>` you target).

---

## **2️⃣ Styling with CSS**

### **2.1. Class‑based styling (most maintainable)**

/* In the <style> block or an external stylesheet */

.big-red {

  fill: crimson;        /* changes the inside colour */

  stroke: #333;         /* optional outline */

  stroke-width: 0.5;

}

<text id="myText" class="big-red" x="20" y="60">Hello SVG!</text>

**Why this works**

* In SVG, the `fill` property is *inherited* from CSS just as it is for HTML text.
* The class can be toggled with JavaScript (`element.classList.toggle('big-red')`).

### **2.2. Using CSS variables for theme‑able colours**

:root {

  --txt-colour: teal;           /* default */

}

/* Use the variable in the SVG */

svg text {

  fill: var(--txt-colour);

}

/* Switch the colour programmatically */

document.documentElement.style.setProperty('--txt-colour', '#c0392b');

### **2.3. `currentColor` – makes the SVG inherit the CSS *text colour* of its container**

/* Set colour on a regular HTML element */

.container { color: darkorange; }

/* SVG text uses that colour */

svg text { fill: currentColor; }

<div class="container">

  <svg width="200" height="40">

    <text x="10" y="30">Inherited colour</text>

  </svg>

</div>

*Result*: The `<text>` appears dark‑orange without any explicit `fill` on the SVG itself.

---

## **3️⃣ Direct SVG attribute (`fill=`)**

<text id="myText" x="20" y="60"

      fill="#ff6600"

      font-family="Arial"

      font-size="40">

  Hello SVG!

</text>

*Pros*

* Works even if the SVG is embedded with `object`/`embed` where external CSS can't reach it.
* No extra CSS needed for a single‑use colour.

*Cons*

* Harder to change later via CSS (the attribute wins over inherited styles).

---

## **4️⃣ Changing colour with JavaScript (runtime)**

You have three typical APIs:

| API | Example | When to pick it |
| ----- | ----- | ----- |
| `setAttribute` | `textEl.setAttribute('fill', '#44a');` | You want to **store the colour as an attribute** (visible in markup when inspected). |
| `style` property | `textEl.style.fill = 'limegreen';` | You prefer **CSS‑style** semantics (does not create an attribute, works like inline `style=`). |
| `classList` manipulation | `textEl.classList.add('green');` | You already have pre‑defined CSS classes; toggling is cheap and keeps style logic separate. |

### **4.1. Simple script**

// demo.js

document.addEventListener('DOMContentLoaded', () => {

  const txt = document.getElementById('myText');

  // 1️⃣ set via attribute

  txt.setAttribute('fill', '#0066ff');

  // 2️⃣ later, replace via style property

  setTimeout(() => {

    txt.style.fill = 'purple';

  }, 1500);

  // 3️⃣ finally, switch using a CSS class

  setTimeout(() => {

    txt.classList.remove('big-red');

    txt.classList.add('green');   // .green defined in the stylesheet

  }, 3000);

});

### **4.2. Using CSS variables from JS (nice for themes)**

// Change the colour for *all* SVG text that uses the var

function setSvgTextColour(colour) {

  document.documentElement.style.setProperty('--txt-colour', colour);

}

// Example usage

setSvgTextColour('indigo');   // instantly updates every text that uses var(--txt-colour)

### **4.3. Changing colour on hover / interaction without extra JS**

svg text { fill: #555; transition: fill 0.2s ease; }

svg text:hover { fill: orange; cursor: pointer; }

No JavaScript needed; the browser takes care of the colour swap.

---

## **5️⃣ Multiple `<tspan>` Elements (different colours in the same line)**

If you need part‑of‑the‑string in a different colour, wrap those parts in `<tspan>` nodes:

<text x="20" y="60" font-size="36" font-family="sans-serif">

  <tspan fill="steelblue">Hello</tspan>

  <tspan fill="crimson" x="120">SVG!</tspan>

</text>

Or, if you prefer class‑based styling:

<text x="20" y="60" font-size="36">

  <tspan class="blue">Hello</tspan>

  <tspan class="red" x="120">SVG!</tspan>

</text>

**Important**: Each `<tspan>` can have its own `x` / `dy` attributes, allowing you to offset them independently while keeping a single logical line.

---

## **6️⃣ Animating colour (SMIL, CSS, or JS)**

### **6.1. CSS animation (recommended for modern browsers)**

@keyframes pulseColor {

  0%   { fill: #ff4d4d; }

  50%  { fill: #4dff4d; }

  100% { fill: #ff4d4d; }

}

svg text.pulse {

  animation: pulseColor 2s infinite;

}

<text class="pulse" x="20" y="60">Animated colour</text>

### **6.2. SMIL (declarative within SVG)**

<text id="myText" x="20" y="90" font-size="32">SMIL Demo</text>

<animate attributeName="fill"

         from="#ff00ff"

         to="#00ffff"

         dur="3s"

         repeatCount="indefinite"/>

**Note**: SMIL is deprecated in some browsers (Edge/IE). CSS or JS animation is safer for future‑proof code.

### **6.3. JavaScript `requestAnimationFrame`**

const text = document.getElementById('myText');

let start = null;

function animate(ts) {

  if (!start) start = ts;

  const progress = (ts - start) / 2000;          // 2‑second cycle

  const hue = Math.floor((progress % 1) * 360);

  text.style.fill = `hsl(${hue}, 80%, 50%)`;

  requestAnimationFrame(animate);

}

requestAnimationFrame(animate);

---

## **7️⃣ Common Gotchas & Best‑Practice Checklist**

| Issue | Why it happens | Fix |
| ----- | ----- | ----- |
| **Colour doesn't change** | You set `style.fill` *but* there is a more specific `fill` **attribute** on the element. Attributes win over inline CSS. | Remove the `fill` attribute (`element.removeAttribute('fill')`) or use `setAttribute` to overwrite it. |
| **SVG inside `<object>` doesn't inherit CSS** | The external SVG is a separate document; external page CSS can't reach it. | Either (a) embed the SVG inline (`<svg>…</svg>`), (b) use `fill=` attribute inside the SVG, or © inject CSS into the SVG document via JS. |
| **Using `color:` instead of `fill:`** | In SVG, `color` only affects properties that explicitly reference `currentColor`. Plain `<text>` ignores plain `color`. | Use `fill` directly, or set `fill: currentColor;` then change `color` on a parent element. |
| **Text becomes invisible on dark backgrounds** | Chosen colour has insufficient contrast. | Use a contrast‑checking tool, or set a subtle `stroke` (e.g., `stroke: white; stroke-width: 0.5;`) to give outline contrast. |
| **Multiple `<tspan>` inherit different colours unexpectedly** | A `<tspan>` without its own `fill` inherits from *its parent*. | Explicitly set `fill` on every `<tspan>` that should stay the same, or rely on inheritance deliberately. |

---

## **8️⃣ Quick‑reference Code Snippets**

### **A. One‑liner to change colour via JS**

document.getElementById('myText').style.fill = '#e74c3c';

### **B. Toggle between two colours on click**

const txt = document.getElementById('myText');

txt.addEventListener('click', () => {

  txt.style.fill = txt.style.fill === 'orange' ? 'steelblue' : 'orange';

});

### **C. Apply a CSS class based on a data attribute**

<text id="myText" data-colour="red" x="20" y="60">Click me</text>

/* Define colour classes */

.red   { fill: #e74c3c; }

.green { fill: #27ae60; }

txt.addEventListener('click', () => {

  const col = txt.dataset.colour;          // "red" or "green"

  txt.className.baseVal = col;            // `baseVal` is the SVG class attribute

});

---

## **9️⃣ TL;DR (the "cheat sheet")**

| How to set static colour | Code |
| ----- | ----- |
| **CSS class** | `<text class="blue">…</text>` + `.blue{fill:blue;}` |
| **CSS variable** | `svg text{fill:var(--txt-colour);}` + `document.documentElement.style.setProperty('--txt-colour','#ff6600');` |
| **Inline SVG attribute** | `<text fill="#ff6600">…</text>` |
| **JS (inline style)** | `el.style.fill = '#ff6600';` |

| How to change dynamically (JS) | Code |
| ----- | ----- |
| `setAttribute` | `el.setAttribute('fill', '#0a7');` |
| `style` property | `el.style.fill = '#0a7';` |
| `classList` toggle | `el.classList.toggle('green');` |
| CSS variable update | `document.documentElement.style.setProperty('--txt-colour','hsl(200,80%,50%)');` |

---

### **🎉 You're ready!**

Pick the approach that matches your project's architecture:

* **Pure CSS** for maintainable theming and hover effects.
* **Attributes** for quick one‑off overrides or when you embed the SVG via `<object>`.
* **JavaScript** for interactive or data‑driven colour changes (charts, maps, games, UI controls).

If you hit a specific edge case (e.g., SVG inside a React component, or colour change on a `<tspan>` inside a `<textPath>`), just drop a follow‑up question and we can dive deeper. Happy coding!
