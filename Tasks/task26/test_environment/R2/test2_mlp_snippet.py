#!/usr/bin/env python3
"""
Test R2 Code Snippet 2: MLP code verbatim
Tests if the code from R2 runs (it shouldn't - X_train/y_train undefined)
"""

print("=" * 60)
print("R2 Test 2: MLP snippet (verbatim)")
print("=" * 60)
print()

print("Attempting to run R2's MLP code exactly as written...")
print("-" * 60)

try:
    # For Neural Networks (MLP)
    from sklearn.neural_network import MLPClassifier

    # Good for small data
    model = MLPClassifier(solver='lbfgs', hidden_layer_sizes=(100,))

    # Better for large data
    # model = MLPClassifier(solver='adam', hidden_layer_sizes=(100,))

    model.fit(X_train, y_train)

    print("✗ UNEXPECTED: Code ran without error")
    print("  This shouldn't happen - X_train/y_train are undefined")
except NameError as e:
    print(f"✓ Got expected NameError: {e}")
    print("  VERDICT: Snippet is INCOMPLETE - missing X_train/y_train definition")
    print("           This is an AOI: code example is not standalone runnable")
except Exception as e:
    print(f"? Got unexpected error: {type(e).__name__}: {e}")

print()
print("=" * 60)
