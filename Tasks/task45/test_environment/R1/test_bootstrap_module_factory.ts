// Test file to verify bootstrapModuleFactory usage
// R1 claims at lines 69, 117, 151, 223, 323 to pass a component ref to bootstrapModuleFactory

import { platformBrowser } from '@angular/platform-browser';
import { NgModuleFactory, Component } from '@angular/core';

// R1 shows this pattern (with non-existent render function):
// const componentRef = renderComponent(document.body, 'app-root');
// platformRef.bootstrapModuleFactory(componentRef);

// Let's test what bootstrapModuleFactory actually expects

@Component({
  selector: 'app-root',
  template: '<h1>Test</h1>'
})
class AppComponent {}

// Simulate what R1 tries to do:
// If we had a component reference (not from render, but just for testing)
const componentRef = AppComponent as any;

// Try to pass it to bootstrapModuleFactory
const platformRef = platformBrowser();

// This should fail because bootstrapModuleFactory expects NgModuleFactory<M>
// not a component reference
// @ts-expect-error - Testing that this is wrong
platformRef.bootstrapModuleFactory(componentRef);

// Correct usage would be:
// platformRef.bootstrapModuleFactory(moduleFactory) where moduleFactory is NgModuleFactory
