export const INITIAL_DEBOUNCE_TIME = 300;
export const MAX_GROW_DEBOUNCE_TIME = 700;
export const MAX_DEBOUNCE_TIME = 900;
export const MAX_CALL_TIMES = 1000;

type DebounceDelayMemo = (initialValue?: number) => () => number;

export const debounceDelay: DebounceDelayMemo = (initialValue = -1) => {
  let i = initialValue;

  return () => {
    i += 1;
    if (i > MAX_CALL_TIMES) {
      return MAX_DEBOUNCE_TIME;
    }

    return Math.min(INITIAL_DEBOUNCE_TIME + ((i * i) / 100), MAX_GROW_DEBOUNCE_TIME);
  };
};
