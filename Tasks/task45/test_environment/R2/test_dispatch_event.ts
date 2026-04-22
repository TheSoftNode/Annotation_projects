// Test file to verify that component classes don't have dispatchEvent method
// R2 claims at lines 332-336 to call this.dispatchEvent() directly

import { Component, ElementRef } from '@angular/core';

@Component({
  selector: 'test-component',
  template: '<div>Test</div>'
})
class TestComponent {
  alpha = 2;
  beta = 2;
  heads = 5;
  tails = 5;

  constructor(private elementRef: ElementRef) {}

  // R2's approach - WRONG:
  private emitStateWrong() {
    // @ts-expect-error - Testing that this method doesn't exist on component
    this.dispatchEvent(new CustomEvent('state-changed', {
      detail: { alpha: this.alpha, beta: this.beta, heads: this.heads, tails: this.tails }
    }));
    // Runtime error: TypeError: this.dispatchEvent is not a function
  }

  // CORRECT approach 1: Use ElementRef
  private emitStateCorrect1() {
    this.elementRef.nativeElement.dispatchEvent(new CustomEvent('state-changed', {
      detail: { alpha: this.alpha, beta: this.beta, heads: this.heads, tails: this.tails }
    }));
  }

  // CORRECT approach 2: Use @Output (more Angular-like)
  // @Output() stateChanged = new EventEmitter<any>();
  //
  // private emitStateCorrect2() {
  //   this.stateChanged.emit({
  //     alpha: this.alpha,
  //     beta: this.beta,
  //     heads: this.heads,
  //     tails: this.tails
  //   });
  // }
}

export { TestComponent };
