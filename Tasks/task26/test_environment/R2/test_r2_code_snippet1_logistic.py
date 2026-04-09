#!/usr/bin/env python3
"""
Test R2's LogisticRegression code snippet from RESPONSE_2 lines 56-60
This tests if the code example provided runs without errors.
"""

print("=" * 70)
print("Testing R2's LogisticRegression code snippet")
print("=" * 70)

try:
    # Exact code from R2's response
    from sklearn.linear_model import LogisticRegression

    model = LogisticRegression(solver='lbfgs', max_iter=1000)

    print("✓ LogisticRegression instantiation successful")
    print(f"  Model: {model}")
    print(f"  Solver: {model.solver}")
    print(f"  Max iterations: {model.max_iter}")
    print("\nVERDICT: R2's LogisticRegression code snippet is CORRECT")
    print("         (though incomplete - no fit/predict shown)")

except Exception as e:
    print(f"✗ Error: {e}")
    print("VERDICT: R2's code snippet FAILED")
