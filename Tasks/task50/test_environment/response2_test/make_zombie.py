import os
import time

pid = os.fork()

if pid == 0:
    os._exit(0)
else:
    print(f"PARENT_PID={os.getpid()}", flush=True)
    print(f"CHILD_PID={pid}", flush=True)
    print("Zombie child should exist while parent sleeps.", flush=True)
    time.sleep(90)
