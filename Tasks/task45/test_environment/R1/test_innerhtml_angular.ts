// Test to demonstrate that setting innerHTML doesn't bootstrap Angular components
// R1 claims at lines 167-171, 337-341 to use innerHTML for Angular components

// This test shows the concept - innerHTML creates DOM but doesn't initialize Angular

// Simulating what R1 suggests:
const mockData = { value: 'test' };

// R1's approach:
const innerHTML_approach = `
  // What R1 suggests:
  document.querySelector('#angular-root').innerHTML = \`
    <app-root data=\${JSON.stringify(mockData)}></app-root>
  \`;

  // This creates DOM elements but:
  // 1. Does NOT compile the Angular component
  // 2. Does NOT set up dependency injection
  // 3. Does NOT initialize change detection
  // 4. The component will NOT function
  // 5. Angular has no knowledge of this element
`;

// Correct approaches for Angular:
const correct_approaches = `
  // Option 1: Use ComponentFactoryResolver (deprecated but works)
  const factory = componentFactoryResolver.resolveComponentFactory(AppComponent);
  const componentRef = viewContainerRef.createComponent(factory);

  // Option 2: Use ViewContainerRef.createComponent (Angular 13+)
  const componentRef = viewContainerRef.createComponent(AppComponent);

  // Option 3: Use Angular Elements (for web components)
  const customElement = createCustomElement(AppComponent, { injector });
  customElements.define('app-root', customElement);

  // Option 4: Bootstrap the entire module
  platformBrowserDynamic().bootstrapModule(AppModule);
`;

console.log('R1 approach (innerHTML):', innerHTML_approach);
console.log('Correct approaches:', correct_approaches);

// The type system can't catch this runtime error, but the approach is fundamentally wrong
export const demonstration = {
  innerHTML_approach,
  correct_approaches
};
