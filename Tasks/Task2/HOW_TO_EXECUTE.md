# How to Execute the Test Files for Task 2

## 🚀 Quick Start (Recommended)

### Step 1: Run Setup (One Time Only)

```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/Task2/test_environment
./setup.sh
```

This will automatically:
- Create a Python virtual environment
- Install all required packages (pandas, numpy, matplotlib, sqlalchemy)
- Set up everything for you

### Step 2: Run All Tests

```bash
./run_all_tests.sh
```

This will run both Response 1 and Response 2 tests automatically.

---

## 📁 Project Structure

```
Task2/
├── RLHF-TASK_2.md                    # Original task with both responses
├── Golden_Annotation_Task2.md        # Complete golden annotation
├── HOW_TO_EXECUTE.md                 # This file
├── README_TESTING.md                 # Detailed documentation
└── test_environment/                 # Self-contained test project
    ├── setup.sh                      # Setup script (run first)
    ├── run_all_tests.sh              # Run all tests
    ├── requirements.txt              # Package dependencies
    ├── test_response1_code.py        # Tests for Response 1
    ├── test_response2_code.py        # Tests for Response 2
    └── README.md                     # Test environment docs
```

---

## 🔧 Manual Testing (Alternative)

If you want to run tests individually:

```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/Task2/test_environment

# Activate virtual environment
source venv/bin/activate

# Run individual tests
python test_response1_code.py
python test_response2_code.py

# Deactivate when done
deactivate
```

---

## 📊 Expected Results

### Response 1 ✅ (Score: 4)
```
Total SKUs analyzed: 5
SKUs where Cost > Rank #1 Price: 1 (20.0%)
Average Required Margin to Be #1: 5.3%

✓ Code works correctly
✓ Produces actionable results
⚠️ Minor issues: FutureWarning, undefined variables
```

### Response 2 ❌ (Score: 2)
```
0 items would be Rank 1.

✗ CRITICAL BUG: moving_to_r1 logic is broken
✗ Always reports 0 items when it should report 5
✗ Logic: final_price = min(proposed, itscope) → always EQUALS, never LESS
```

---

## 🛠️ Troubleshooting

**Problem:** `./setup.sh` permission denied
**Solution:**
```bash
chmod +x setup.sh
./setup.sh
```

**Problem:** Python not found
**Solution:** Make sure Python 3 is installed:
```bash
python3 --version
```

**Problem:** Virtual environment issues
**Solution:** Delete and recreate:
```bash
rm -rf venv
./setup.sh
```

---

## 📚 What Gets Verified

Both test scripts verify all claims made in the Golden Annotation:

1. ✅ Code execution (does it run?)
2. ✅ Correctness (does it produce right results?)
3. ✅ Errors and warnings (FutureWarning in R1)
4. ✅ Logic flaws (moving_to_r1 bug in R2)
5. ✅ All Areas of Improvement with sources

Everything is executable and verifiable!
