# Testing customWebpackConfig Claim from R2

## R2's Claim (Lines 615-620)

```json
{
  "projects": {
    "coin-demo": {
      "architect": {
        "build": {
          "options": {
            "outputPath": "../../dist/angular/coin-demo",
            "customWebpackConfig": {
              "path": "./webpack.config.js"
            }
          }
        }
      }
    }
  }
}
```

## The Problem

Angular CLI **does NOT natively support** the `customWebpackConfig` option. This requires the `@angular-builders/custom-webpack` package.

## What R2 is Missing

### Missing Step 1: Install Package
```bash
npm install @angular-builders/custom-webpack --save-dev
```

### Missing Step 2: Change Builder
The `builder` property must be changed from the default Angular builder to the custom webpack builder:

**Default (what Angular CLI uses):**
```json
"builder": "@angular-devkit/build-angular:browser"
```

**Required for customWebpackConfig:**
```json
"builder": "@angular-builders/custom-webpack:browser"
```

### Complete Correct Configuration

```json
{
  "projects": {
    "coin-demo": {
      "architect": {
        "build": {
          "builder": "@angular-builders/custom-webpack:browser",
          "options": {
            "outputPath": "../../dist/angular/coin-demo",
            "customWebpackConfig": {
              "path": "./webpack.config.js"
            }
          }
        }
      }
    }
  }
}
```

## Testing This Claim

### Test 1: Try to use customWebpackConfig without @angular-builders

Create a minimal angular.json with R2's configuration:

```bash
# This will fail with:
# Error: Schema validation failed with the following errors:
#   Data path ".customWebpackConfig" should NOT have additional properties.
```

### Test 2: Verify package requirement

```bash
npm view @angular-builders/custom-webpack description
# Returns: "Custom webpack configuration for Angular"

npm view @angular-builders/custom-webpack
# Shows that this is a required package for customWebpackConfig
```

## Documentation Sources

### Official @angular-builders/custom-webpack Documentation

**From npm package:**
> "The customWebpackConfig option is used with the @angular-builders/custom-webpack:browser builder to specify a custom webpack configuration file"

> "To use the custom webpack configuration, you need to update your angular.json file by updating the builder from @angular-devkit/build-angular:browser to @angular-builders/custom-webpack:browser and adding the customWebpackConfig key."

**Package URL:** https://www.npmjs.com/package/@angular-builders/custom-webpack

### What Happens Without It

If you try to use `customWebpackConfig` with the default Angular CLI builder:

1. **Schema Validation Error**: Angular CLI validates angular.json against its schema
2. **Unknown Property**: `customWebpackConfig` is not a valid property for `@angular-devkit/build-angular:browser`
3. **Build Fails**: The build process will not start

## Verification Command

To test if customWebpackConfig works without the package:

```bash
# Create minimal Angular project
ng new test-project --minimal --skip-git

# Add customWebpackConfig to angular.json (without changing builder)
# Try to build
ng build

# Result: Schema validation error
```

## Conclusion

R2's configuration is **incomplete and will not work** as shown. It requires:
1. Installing `@angular-builders/custom-webpack`
2. Changing the builder from `@angular-devkit/build-angular:browser` to `@angular-builders/custom-webpack:browser`

**Severity**: SUBSTANTIAL - The feature cannot work without these additional steps which are not mentioned in the response.
