// Test file to VERIFY that R2's Angular Elements approach is CORRECT
// This tests the CORRECT parts of R2's implementation

import { Component, NgModule, Injector } from '@angular/core';
import { createCustomElement } from '@angular/elements';

@Component({
  selector: 'correct-demo',
  template: '<div>Correct Demo Component</div>'
})
class CorrectDemoComponent {}

// R2's CORRECT approach (minus the deprecated entryComponents)
@NgModule({
  declarations: [CorrectDemoComponent]
  // Note: entryComponents removed (deprecated)
})
export class CorrectDemoModule {
  constructor(private injector: Injector) {
    // ✅ CORRECT: createCustomElement from @angular/elements
    const customElement = createCustomElement(CorrectDemoComponent, { injector });

    // ✅ CORRECT: customElements.define() to register web component
    customElements.define('correct-demo', customElement);
  }

  // ✅ CORRECT: ngDoBootstrap for custom bootstrapping
  ngDoBootstrap() {}
}

// This pattern is CORRECT and documented in Angular Elements guide:
// https://angular.dev/guide/elements

/*
 * VERIFICATION:
 *
 * 1. createCustomElement - ✅ Exists in @angular/elements
 *    Source: https://angular.dev/api/elements/createCustomElement
 *
 * 2. customElements.define() - ✅ Web Components standard API
 *    Source: https://developer.mozilla.org/en-US/docs/Web/API/CustomElementRegistry/define
 *
 * 3. ngDoBootstrap() - ✅ Angular bootstrapping hook for custom elements
 *    Source: https://angular.dev/api/core/NgModule#ngDoBootstrap
 *
 * CONCLUSION: R2's core Angular Elements approach is SOUND and CORRECT
 */
