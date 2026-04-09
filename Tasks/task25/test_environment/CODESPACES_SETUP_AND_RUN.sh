#!/bin/bash
# Complete setup and test runner for GitHub Codespaces
# This script sets up the Linux kernel source and runs ALL tests for Task 25

echo "============================================================"
echo "TASK 25 - CODESPACES COMPLETE SETUP AND TEST RUNNER"
echo "Topic: 'So wouldn't floats be better?' (HFT trading)"
echo "============================================================"
echo

# ============================================================
# PART 1: INSTALL DEPENDENCIES
# ============================================================

echo "============================================================"
echo "PART 1: Installing dependencies..."
echo "============================================================"
echo

sudo apt update
sudo apt install -y git build-essential bc flex bison libelf-dev libssl-dev python3

echo
echo "Dependencies installed successfully"
echo

# ============================================================
# PART 2: CLONE LINUX KERNEL SOURCE (for R2 tests)
# ============================================================

echo "============================================================"
echo "PART 2: Cloning Linux kernel source..."
echo "============================================================"
echo

if [ ! -d "$HOME/linux" ]; then
    cd $HOME
    git clone --depth 1 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
    echo "Linux kernel source cloned to $HOME/linux"
else
    echo "Linux kernel source already exists at $HOME/linux"
fi

echo

# ============================================================
# PART 3: RUN ALL R1 TESTS
# ============================================================

cd /workspaces/*/Tasks/task25/test_environment || cd ~/task25/test_environment || {
    echo "ERROR: Could not find task25/test_environment directory"
    exit 1
}

echo "============================================================"
echo "PART 3: Running all R1 tests..."
echo "============================================================"
echo

mkdir -p outputs/R1

echo "--- R1 Test A, B, C: Python Floating-Point Behavior ---"
if [ -f "R1/test_r1_python.py" ]; then
    python3 R1/test_r1_python.py | tee outputs/R1/r1_python_output.txt
    echo
fi

echo "--- R1 Test D: -ffast-math Compiler Flag ---"
if [ -f "R1/test_r1_ffast_math.sh" ]; then
    bash R1/test_r1_ffast_math.sh | tee outputs/R1/r1_ffast_math_output.txt
    echo
fi

echo "--- R1 Test E: __int128 Availability ---"
if [ -f "R1/test_r1_int128.sh" ]; then
    bash R1/test_r1_int128.sh | tee outputs/R1/r1_int128_output.txt
    echo
fi

echo "--- R1 Test F: NaN and Infinity Behavior ---"
if [ -f "R1/test_r1_fp_specials.sh" ]; then
    bash R1/test_r1_fp_specials.sh | tee outputs/R1/r1_fp_specials_output.txt
    echo
fi

# ============================================================
# PART 4: RUN CONVERSATION HISTORY TESTS
# ============================================================

echo "============================================================"
echo "PART 4: Running conversation history tests..."
echo "============================================================"
echo

if [ -f "test_conversation_history_code.sh" ]; then
    bash test_conversation_history_code.sh | tee outputs/conversation_history_output.txt
    echo
fi

# ============================================================
# PART 5: RUN ALL R2 TESTS (Linux kernel verification)
# ============================================================

echo "============================================================"
echo "PART 5: Running all R2 kernel verification tests..."
echo "============================================================"
echo
echo "NOTE: R2 is OFF-TOPIC - answers about Linux kernel instead of floats"
echo

mkdir -p outputs/R2

# Copy R2 test scripts to Linux kernel source directory
cp -r R2/*.sh $HOME/linux/

cd $HOME/linux

echo "Running R2 Step B: schedule_work() declaration..."
bash test_step_B_schedule_work.sh | tee /workspaces/*/Tasks/task25/test_environment/outputs/R2/step_B_output.txt 2>&1 || \
    tee ~/task25/test_environment/outputs/R2/step_B_output.txt 2>&1
echo

echo "Running R2 Step C: delayed_work..."
bash test_step_C_delayed_work.sh | tee /workspaces/*/Tasks/task25/test_environment/outputs/R2/step_C_output.txt 2>&1 || \
    tee ~/task25/test_environment/outputs/R2/step_C_output.txt 2>&1
echo

echo "Running R2 Step D: queue_work..."
bash test_step_D_queue_work.sh | tee /workspaces/*/Tasks/task25/test_environment/outputs/R2/step_D_output.txt 2>&1 || \
    tee ~/task25/test_environment/outputs/R2/step_D_output.txt 2>&1
echo

echo "Running R2 Step E: flush_work..."
bash test_step_E_flush_work.sh | tee /workspaces/*/Tasks/task25/test_environment/outputs/R2/step_E_output.txt 2>&1 || \
    tee ~/task25/test_environment/outputs/R2/step_E_output.txt 2>&1
echo

echo "Running R2 Step F: cancel APIs..."
bash test_step_F_cancel_apis.sh | tee /workspaces/*/Tasks/task25/test_environment/outputs/R2/step_F_output.txt 2>&1 || \
    tee ~/task25/test_environment/outputs/R2/step_F_output.txt 2>&1
echo

echo "Running R2 Step G: worker naming..."
bash test_step_G_worker_naming.sh | tee /workspaces/*/Tasks/task25/test_environment/outputs/R2/step_G_output.txt 2>&1 || \
    tee ~/task25/test_environment/outputs/R2/step_G_output.txt 2>&1
echo

echo "Running R2 Step H: mutex and sleep..."
bash test_step_H_mutex_sleep.sh | tee /workspaces/*/Tasks/task25/test_environment/outputs/R2/step_H_output.txt 2>&1 || \
    tee ~/task25/test_environment/outputs/R2/step_H_output.txt 2>&1
echo

echo "Running R2 Step I: user-space memory (SUSPICIOUS)..."
bash test_step_I_user_space_memory.sh | tee /workspaces/*/Tasks/task25/test_environment/outputs/R2/step_I_output.txt 2>&1 || \
    tee ~/task25/test_environment/outputs/R2/step_I_output.txt 2>&1
echo

echo "Running R2 Step J: concurrent execution..."
bash test_step_J_concurrent_execution.sh | tee /workspaces/*/Tasks/task25/test_environment/outputs/R2/step_J_output.txt 2>&1 || \
    tee ~/task25/test_environment/outputs/R2/step_J_output.txt 2>&1
echo

# ============================================================
# FINAL SUMMARY
# ============================================================

cd /workspaces/*/Tasks/task25/test_environment || cd ~/task25/test_environment

echo "============================================================"
echo "ALL TESTS COMPLETE"
echo "============================================================"
echo
echo "Output files location:"
echo "  R1 outputs: outputs/R1/"
echo "  R2 outputs: outputs/R2/"
echo "  Conversation history: outputs/"
echo
echo "Next steps:"
echo "  1. Review all output files"
echo "  2. Use outputs as verification for AOIs"
echo "  3. Note R2's off-topic issue as major AOI"
echo
echo "============================================================"
