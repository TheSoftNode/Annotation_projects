// src/index.ts

export interface DebouncedFunction<F extends (...args: any[]) => Promise<any>> {
  (...args: Parameters<F>): ReturnType<F>;
  cancel(): void;
  flush(): ReturnType<F> | undefined;
  pending(): boolean;
}

export function debouncePromise<F extends (...args: any[]) => Promise<any>>(
  fn: F,
  wait: number,
  options: {
    leading?: boolean;
    trailing?: boolean;
    ordered?: boolean; // Ensure results resolve in call order
  } = {}
): DebouncedFunction<F> {
  let timer: ReturnType<typeof setTimeout> | null = null;
  let lastArgs: Parameters<F> | null = null;
  let resolveQueue: Array<(value: ReturnType<F>) => void> = [];
  let rejectQueue: Array<(reason: any) => void> = [];
  let resultPromise: ReturnType<F> | null = null;
  let lastCallTime: number | null = null;

  const {
    leading = false,
    trailing = true,
    ordered = true,
  } = options;

  const invoke = (): void => {
    if (!lastArgs || (!leading && !trailing)) return;

    const callTime = Date.now();
    const shouldCall = (leading && !lastCallTime) ||
                      (trailing && callTime - (lastCallTime || 0) >= wait);

    if (shouldCall) {
      const args = lastArgs;
      lastArgs = null;
      lastCallTime = callTime;

      try {
        resultPromise = fn.apply(null, args) as ReturnType<F>;
        const promise = resultPromise;

        // Resolve all queued promises in order
        promise.then(
          (value) => {
            if (ordered) {
              while (resolveQueue.length) resolveQueue.shift()!(value);
            } else {
              // Fire all immediately
              resolveQueue.forEach((r) => r(value));
              resolveQueue = [];
            }
          },
          (error) => {
            while (rejectQueue.length) rejectQueue.shift()!(error);
            resolveQueue = [];
          }
        );
      } catch (err) {
        while (rejectQueue.length) rejectQueue.shift()!(err);
        resolveQueue = [];
      }
    }
  };

  const debounced = function (this: any, ...args: Parameters<F>): ReturnType<F> {
    lastArgs = args;

    if (!timer) {
      if (leading) {
        invoke();
      }
      const delay = leading && !lastCallTime ? wait : Math.max(wait - (Date.now() - (lastCallTime || 0)), 0);
      timer = setTimeout(() => {
        timer = null;
        invoke();
      }, delay);
    }

    return new Promise((resolve, reject) => {
      resolveQueue.push(resolve);
      rejectQueue.push(reject);
    }) as ReturnType<F>;
  };

  debounced.cancel = () => {
    if (timer) {
      clearTimeout(timer);
      timer = null;
    }
    lastArgs = null;
    resolveQueue = [];
    rejectQueue = [];
    resultPromise = null;
  };

  debounced.flush = () => {
    if (!resultPromise && lastArgs) {
      invoke(); // Force invoke now
    }
    return resultPromise;
  };

  debounced.pending = () => !!timer;

  return debounced as DebouncedFunction<F>;
}

export default debouncePromise;
