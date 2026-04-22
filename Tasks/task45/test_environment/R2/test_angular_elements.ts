// Test file to verify Angular Elements createCustomElement API
// This is claimed in Response 2 at lines 364-386

import { Component, Injector, NgModule } from '@angular/core';
import { createCustomElement } from '@angular/elements';

@Component({
  selector: 'test-component',
  template: '<h1>Test</h1>'
})
class TestComponent {}

@NgModule({
  declarations: [TestComponent],
  // Testing deprecated entryComponents - should work but show warning
  entryComponents: [TestComponent]
})
class TestModule {
  constructor(private injector: Injector) {
    const customElement = createCustomElement(TestComponent, { injector });
    customElements.define('test-element', customElement);
  }

  ngDoBootstrap() {}
}

console.log('Angular Elements test setup complete');
