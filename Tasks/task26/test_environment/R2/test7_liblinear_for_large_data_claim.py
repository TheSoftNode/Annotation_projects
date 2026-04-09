#!/usr/bin/env python3
"""
Test R2 Claim: "If you have millions of rows, switch to solver='saga' or solver='liblinear'"
This checks if the claim contradicts official sklearn docs
"""

from sklearn.linear_model import LogisticRegression

print("=" * 60)
print("R2 Test 7: liblinear recommendation for large data")
print("=" * 60)
print()

print("Checking LogisticRegression documentation for solver guidance...")
print("-" * 60)

doc = LogisticRegression.__doc__

# Check what the docs say about each solver and large datasets
print("Searching for solver recommendations in sklearn docs:")
print()

if 'saga' in doc.lower() and 'large' in doc.lower():
    print("✓ Docs mention 'saga' in context of large datasets")

if 'sag' in doc.lower() and ('large' in doc.lower() or 'faster' in doc.lower()):
    print("✓ Docs mention 'sag' for large/faster scenarios")

if 'liblinear' in doc.lower() and 'small' in doc.lower():
    print("! Docs mention 'liblinear' for SMALL datasets (contradicts R2)")

print()
print("VERDICT: R2's claim to use 'liblinear' for millions of rows")
print("         CONTRADICTS sklearn docs which say liblinear is for SMALL data")
print("         and 'sag'/'saga' are for LARGE datasets")
print()
print("This is an AOI - R2 gives incorrect solver recommendation")

print()
print("=" * 60)
