import React, { forwardRef, useEffect, useImperativeHandle, useMemo, useRef, useState } from 'preact/compat';
import { delay } from 'lodash';
import { debounceDelay } from 'js/home/search/embedded_app/helpers/SearchBoxHelper';

// eslint-disable-next-line @typescript-eslint/no-var-requires
const searchIcon = require('../../../../../images/home/search.svg');

interface Props {
  currentRefinement: string;

  refine(value?: string): void;

  onFocus: () => void;
  onBlur: () => void;
}

export type SearchBoxRef = {
  autocompleteSearch: (string) => void,
};

const SearchBox = forwardRef<SearchBoxRef, Props>(({ currentRefinement, refine, onFocus, onBlur }, ref) => {
  const [currentInputValue, setCurrentInputValue] = useState(currentRefinement);
  const [debounceTimerId, setDebounceTimerId] = useState(null);
  const currentDelay = useMemo(() => debounceDelay(), []);
  const inputRef = useRef<HTMLInputElement>();

  const debouncedSearch = (value) => {
    if (debounceTimerId) {
      clearInterval(debounceTimerId);
    }

    setDebounceTimerId(delay(refine, currentDelay(), value));
  };

  useImperativeHandle(ref, () => ({
    autocompleteSearch: (value) => {
      setCurrentInputValue(value);
      refine(value);
      inputRef.current.blur();
    },
  }));

  useEffect(() => {
    const term = currentInputValue.trim();
    if (term !== currentRefinement && (term.length > 1 || term.length === 0)) {
      debouncedSearch(term);
    }
  }, [currentInputValue]);

  return (
    <div className="search-field">
      <input
        ref={inputRef}
        type="search"
        value={currentInputValue}
        placeholder={MyZivi.translations.search.searchPlaceholder}
        onFocus={onFocus}
        onBlur={onBlur}
        onChange={(e) => setCurrentInputValue(e.currentTarget.value)}
        onKeyUp={
          (e) => {
            if (e.key.toLowerCase() === 'enter') {
              inputRef.current.blur();
            }
          }
        }
      />

      <button className="search-button" onClick={() => inputRef.current.blur()}>
        <img src={searchIcon} alt={MyZivi.translations.search.search} className="w-100 h-100" />
      </button>
    </div>
  );
});

SearchBox.displayName = 'SearchBox';
export default SearchBox;
