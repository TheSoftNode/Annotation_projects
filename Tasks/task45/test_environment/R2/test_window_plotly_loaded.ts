// Test file to verify that window.plotlyLoaded causes TypeScript error
// R2 uses this at line 194, 204 without type declaration

// This will fail in strict TypeScript:
function testWindowProperty() {
  // @ts-expect-error - Property 'plotlyLoaded' does not exist on type 'Window & typeof globalThis'
  if (!window.plotlyLoaded) {
    const script = document.createElement('script');
    script.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
    script.async = true;
    script.onload = () => {
      // @ts-expect-error - Same error here
      window.plotlyLoaded = true;
    };
    document.head.appendChild(script);
  }
}

// CORRECT approach: Extend Window interface
declare global {
  interface Window {
    plotlyLoaded?: boolean;
    Plotly?: any;
  }
}

// Now this works:
function testWindowPropertyCorrect() {
  if (!window.plotlyLoaded) {
    const script = document.createElement('script');
    script.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
    script.async = true;
    script.onload = () => {
      window.plotlyLoaded = true;
    };
    document.head.appendChild(script);
  }
}

export { testWindowProperty, testWindowPropertyCorrect };
