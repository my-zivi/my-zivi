import React from 'preact/compat';
import { FunctionalComponent } from 'preact';

const CardHeader: FunctionalComponent<{ overviewSubtitle: string }> = ({ overviewSubtitle }) => (
  <div class="card-header bg-light">
    <div class="d-flex align-items-center">
      <h5>{MyZivi.translations.servicesOverview.title}</h5>
    </div>
    <h6 class="text-muted mb-0">
      {overviewSubtitle}
    </h6>
  </div>
);

export default CardHeader;
