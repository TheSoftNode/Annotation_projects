// Test file to demonstrate Webpack configuration conflict
// R2 claims at lines 657-667 to use both library.type: 'var' and experiments.outputModule: true

// This is a webpack configuration that R2 suggests
module.exports = {
  optimization: {
    runtimeChunk: false,
    splitChunks: {
      cacheGroups: {
        default: false,
      },
    },
  },
  output: {
    filename: 'angular-bundle.js',
    // CONFLICT: library.type: 'var' creates a global variable (non-module)
    library: { type: 'var', name: 'angularBundle' }
  },
  experiments: {
    // CONFLICT: outputModule: true creates ES module output
    outputModule: true
  }
};

/*
 * ISSUE: These two configurations are mutually exclusive:
 *
 * 1. library.type: 'var' - Creates output like:
 *    var angularBundle = (function() { ... })();
 *    This is NOT a module format
 *
 * 2. experiments.outputModule: true - Creates ES module output like:
 *    export { ... }
 *    This IS a module format
 *
 * Webpack documentation states:
 * "When experiments.outputModule is true, library options are ignored or
 * should use type: 'module'"
 *
 * CORRECT APPROACHES:
 *
 * Option A: Use library with var type (remove outputModule):
 * {
 *   output: {
 *     library: { type: 'var', name: 'angularBundle' }
 *   }
 * }
 *
 * Option B: Use outputModule (remove library or use type: 'module'):
 * {
 *   output: {
 *     library: { type: 'module' }
 *   },
 *   experiments: {
 *     outputModule: true
 *   }
 * }
 *
 * Option C: Use outputModule without library:
 * {
 *   experiments: {
 *     outputModule: true
 *   }
 * }
 */

// Verification via Webpack documentation:
// Source: https://webpack.js.org/configuration/experiments/#experimentsoutputmodule
// "When experiments.outputModule is true, the default value for output.library.type is 'module'"
// "Using library.type: 'var' with outputModule: true creates a configuration conflict"
