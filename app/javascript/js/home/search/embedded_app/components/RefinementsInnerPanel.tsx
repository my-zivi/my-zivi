import { ClearRefinements, connectRefinementList } from 'react-instantsearch-dom';
import React from 'preact/compat';
import { Collapse } from 'react-bootstrap';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { mobile } from 'is_js';
import { IconName } from '@fortawesome/fontawesome-svg-core';
import {
  CantonDisplayNameRefinement,
  CategoryDisplayNameRefinement,
  LanguageRefinement,
  MinimumServiceMonthsRefinement,
  PriorityProgramRefinement,
} from './refinements';

const VirtualRefinementList = connectRefinementList(() => <></>);

class RefinementsInnerPanel extends React.Component<{ clearFiltersInsideCard?: boolean }, { isCollapsed: boolean }> {
  constructor() {
    super();
    this.state = { isCollapsed: mobile() };
  }

  private panelContent(): JSX.Element {
    return (
      <div className="mt-3">
        <strong>{MyZivi.translations.search.refinements.language}</strong>
        <LanguageRefinement />
        <hr />
        <strong>{MyZivi.translations.search.refinements.category}</strong>
        <CategoryDisplayNameRefinement />
        <hr />
        <strong>{MyZivi.translations.search.refinements.canton}</strong>
        <CantonDisplayNameRefinement />
        <hr />
        <strong>{MyZivi.translations.search.refinements.minimumServiceMonths}</strong>
        <MinimumServiceMonthsRefinement />
        <hr />
        <strong>{MyZivi.translations.search.refinements.priorityProgram}</strong>
        <PriorityProgramRefinement />
        <VirtualRefinementList attribute={'internal_tag'} defaultRefinement={['coordinates_present']} />
        {this.props.clearFiltersInsideCard === true && RefinementsInnerPanel.getClearRefinements()}
        <div className="d-block d-lg-none mt-2">
          {this.collapseButton('chevron-down', 'chevron-up')}
        </div>
      </div>
    );
  }

  private collapseButton(collapsedIcon: IconName = 'chevron-up', expandedIcon: IconName = 'chevron-down') {
    return (
      <a className="mx-0 w-100 d-block"
         href="#"
         onClick={(e) => {
           e.preventDefault();
           this.setState({ isCollapsed: !this.state.isCollapsed });
         }}
      >
        {this.state.isCollapsed
          ? <FontAwesomeIcon icon={['fas', collapsedIcon]} className="mr-1" />
          : <FontAwesomeIcon icon={['fas', expandedIcon]} className="mr-1" />}
        {MyZivi.translations.search.refinements.collapseButton}
      </a>
    );
  }

  render(): JSX.Element {
    return (
      <>
        <div className="card card-body">
          {this.collapseButton()}
          <Collapse in={!this.state.isCollapsed}>
            {this.panelContent()}
          </Collapse>
        </div>
        {!this.props.clearFiltersInsideCard && RefinementsInnerPanel.getClearRefinements()}
      </>
    );
  }

  private static getClearRefinements() {
    const { refinements: { controls: { reset } } } = MyZivi.translations.search;

    return <ClearRefinements clearsQuery={false} className="my-3" translations={{ reset }} />;
  }
}

export default RefinementsInnerPanel;
