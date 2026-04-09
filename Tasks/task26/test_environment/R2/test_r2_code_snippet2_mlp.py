#!/usr/bin/env python3
"""
Test R2's MLPClassifier code snippet from RESPONSE_2 lines 62-74
This tests if the code example provided runs without errors.
Expected: WILL FAIL due to undefined X_train, y_train
"""

print("=" * 70)
print("Testing R2's MLPClassifier code snippet (EXPECTED TO FAIL)")
print("=" * 70)

try:
    # Exact code from R2's response
    from sklearn.neural_network import MLPClassifier

    # Good for small data
    model = MLPClassifier(solver='lbfgs', hidden_layer_sizes=(100,))

    print("✓ MLPClassifier instantiation successful")
    print(f"  Model: {model}")
    print(f"  Solver: {model.solver}")

    # This line from R2's response will fail
    print("\nAttempting model.fit(X_train, y_train) as shown in R2...")
    model.fit(X_train, y_train)

    print("✓ Code completed successfully")

except NameError as e:
    print(f"✗ NameError: {e}")
    print("\nVERDICT: R2's code snippet is INCOMPLETE")
    print("         X_train and y_train are never defined")
    print("         This code cannot be run as-is")

except Exception as e:
    print(f"✗ Unexpected error: {e}")
    print("VERDICT: R2's code snippet FAILED with unexpected error")
