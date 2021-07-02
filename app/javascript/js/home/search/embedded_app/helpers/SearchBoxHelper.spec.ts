import {
  debounceDelay, INITIAL_DEBOUNCE_TIME, MAX_CALL_TIMES, MAX_DEBOUNCE_TIME,
} from './SearchBoxHelper';

describe('SearchBoxHelper', () => {
  describe('#debounceDelay', () => {
    it('returns initial debounce time when invoked for the first time', () => {
      expect(debounceDelay()()).toEqual(INITIAL_DEBOUNCE_TIME);
    });

    it('returns longer debounce when invoked multiple times', () => {
      const debouncer = debounceDelay();
      debouncer();
      const secondCall = debouncer();
      expect(secondCall).toBeCloseTo(INITIAL_DEBOUNCE_TIME, 1);
      expect(secondCall).not.toEqual(INITIAL_DEBOUNCE_TIME);
    });

    it('returns maximum when called the max call times', () => {
      const debouncer = debounceDelay(MAX_CALL_TIMES);
      expect(debouncer()).toEqual(MAX_DEBOUNCE_TIME);
      expect(debouncer()).toEqual(MAX_DEBOUNCE_TIME);
    });
  });
});
