// Test file to verify if @angular/core exports a 'render' function
// This is claimed in Response 1 at lines 53-54

import { render } from '@angular/core';
import { enableProdMode } from '@angular/core';

// If this compiles, the API exists
// If it fails with "Module '"@angular/core"' has no exported member 'render'", then R1 is wrong

enableProdMode();
const result = render;
console.log(typeof result);
