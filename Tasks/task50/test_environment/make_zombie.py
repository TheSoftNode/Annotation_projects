import os
import time

pid = os.fork()

if pid == 0:
    os._exit(0)
else:
    print(f"Parent PID: {os.getpid()}")
    print(f"Child PID: {pid}")
    print("A zombie child process should exist while this script sleeps.")
    time.sleep(60)
