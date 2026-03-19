# Task 2 Test Environment

This is a self-contained testing environment for verifying the code from both responses in Task 2.

## Quick Setup and Run

### One-Time Setup

```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/Task2/test_environment
./setup.sh
```

This will:
- Create a Python virtual environment
- Install all required packages (pandas, numpy, matplotlib, sqlalchemy)
- Set everything up automatically

### Running the Tests

After setup, the virtual environment will be activated. Simply run:

```bash
python test_response1_code.py
python test_response2_code.py
```

## Files in This Directory

- `setup.sh` - Automated setup script (run this first)
- `requirements.txt` - Python package dependencies
- `test_response1_code.py` - Tests for Response 1
- `test_response2_code.py` - Tests for Response 2
- `README.md` - This file

## Manual Setup (if setup.sh doesn't work)

```bash
# Create virtual environment
python3 -m venv venv

# Activate it
source venv/bin/activate

# Install packages
pip install -r requirements.txt

# Run tests
python test_response1_code.py
python test_response2_code.py
```

## Expected Results

### Response 1 ✅
- All code executes successfully
- Produces correct rank 1 prices
- Correctly identifies SKUs where cost > rank 1 price
- Calculates required margins accurately
- Minor issues: FutureWarning, undefined variables in optional function
- **Quality Score: 4**

### Response 2 ❌
- Code executes without syntax errors
- **CRITICAL BUG**: `moving_to_r1` logic is broken
- Always reports 0 items achieving Rank 1
- Logic: `final_price = min(proposed, itscope)` means final will EQUAL itscope, never LESS
- Therefore: `moving_to_r1 = (final_price < itscope_price)` is always False
- **Quality Score: 2**

## Deactivating Environment

When done testing:
```bash
deactivate
```

## Reactivating Environment Later

```bash
cd /Users/apple/Desktop/Applyloop-project3/Tasks/Task2/test_environment
source venv/bin/activate
```

Then run tests again as needed.
