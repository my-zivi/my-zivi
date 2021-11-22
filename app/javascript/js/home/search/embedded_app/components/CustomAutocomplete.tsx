import * as React from 'preact/compat';
import { AutocompleteProvided, connectAutoComplete } from 'react-instantsearch-core';
import { JobPostingSearchHit } from 'js/home/search/embedded_app/types';
import {
  isEmpty, isInteger, take, uniqBy,
} from 'lodash';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import SearchBox, { SearchBoxRef } from './SearchBox';

type Props = AutocompleteProvided<JobPostingSearchHit>;
type State = {
  focused: boolean,
  isHovering: boolean,
  selectedHitIndex?: number,
};

export class AutocompleteImpl extends React.Component<Props, State> {
  private readonly searchBoxRef;
  private flattenedHits: JobPostingSearchHit[] = [];

  constructor(props: Props) {
    super(props);
    this.searchBoxRef = React.createRef<SearchBoxRef>();
    this.state = {
      focused: false,
      isHovering: false,
      selectedHitIndex: undefined,
    };
  }

  componentDidMount(): void {
    document.addEventListener('keyup', this.onKeyup);
  }

  componentWillUnmount(): void {
    document.removeEventListener('keyup', this.onKeyup);
  }

  componentWillUpdate(nextProps: Readonly<Props>): void {
    this.flattenedHits = take(uniqBy(nextProps.hits, (hit) => hit.title), 10);
  }

  render(): JSX.Element {
    return (
      <>
        <SearchBox
          ref={this.searchBoxRef}
          currentRefinement={this.props.currentRefinement}
          refine={this.props.refine}
          onFocus={() => this.showAutocomplete()}
          onBlur={() => this.collapseAutocomplete()}
        />
        <div className={this.autocompleteContainerClass()}>
          <div
            className="autocomplete-content"
            onMouseEnter={() => this.setState({ isHovering: true })}
            onTouchStart={() => this.setState({ isHovering: true })}
            onTouchEnd={() => this.setState({ isHovering: false })}
            onMouseLeave={() => this.setState({ isHovering: false })}
          >
            {this.renderHitsList()}
          </div>
        </div>
      </>
    );
  }

  private onKeyup = (event: KeyboardEvent) => {
    let { selectedHitIndex } = this.state;

    switch (event.key.toLocaleLowerCase()) {
      case 'arrowup':
        selectedHitIndex = (selectedHitIndex || this.flattenedHits.length) - 1;
        break;
      case 'arrowdown':
        selectedHitIndex = !isInteger(selectedHitIndex) ? 0 : selectedHitIndex + 1;
        break;
      case 'enter':
        this.onAutocompleteHitClick(this.flattenedHits[selectedHitIndex]);
        return;
      default:
        break;
    }

    selectedHitIndex %= this.flattenedHits.length;
    this.setState({ selectedHitIndex });
  };

  private collapseAutocomplete() {
    this.setState({ focused: false });
  }

  private showAutocomplete() {
    this.setState({ focused: true, selectedHitIndex: undefined });
  }

  private renderHitsList() {
    return (
      <ul>
        {this.flattenedHits.map((hit, index) => (
          <a
            href="#"
            key={hit.objectID}
            onClick={(e) => this.onAutocompleteHitClick(hit, e)}
            className="autocomplete-hit"
          >
            <li
              className={this.state.selectedHitIndex === index ? 'selected' : undefined}
              onMouseOver={() => this.setState({ selectedHitIndex: index })}
            >
              <FontAwesomeIcon icon={['fas', 'search']} className="mr-2" />
              {hit.title}
            </li>
          </a>
        ))}
      </ul>
    );
  }

  private onAutocompleteHitClick(hit?: JobPostingSearchHit, event?: MouseEvent) {
    event?.preventDefault();
    if (!hit) {
      return;
    }

    this.searchBoxRef.current.autocompleteSearch(hit.title);
    this.setState({ isHovering: false, focused: false, selectedHitIndex: undefined });
  }

  private autocompleteContainerClass() {
    const canPresent = this.state.focused || this.state.isHovering;
    const isVisible = canPresent && !isEmpty(this.props.currentRefinement) && !isEmpty(this.props.hits);
    return `autocomplete-container ${isVisible ? 'd-block' : 'd-none'}`;
  }
}

export default connectAutoComplete(AutocompleteImpl as never);
