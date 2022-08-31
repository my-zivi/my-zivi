import { Stats } from 'react-instantsearch-dom';
import PoweredBy from 'js/home/search/embedded_app/components/PoweredBy';
import CustomHitComponent from 'js/home/search/embedded_app/components/CustomHitComponent';
import RefinementsPanel from 'js/home/search/embedded_app/components/RefinementsPanel';
import React from 'preact/compat';

export default () => (
  <div className="container mt-6 mb-3">
    <div className="d-flex justify-content-start justify-content-lg-end mb-2">
      <div className="text-muted mr-1">
        <Stats translations={{
          stats(hitsCount, processingTimeMS) {
            return MyZivi.translations.search.statistics
              .replace('%{count}', hitsCount.toLocaleString())
              .replace('%{time}', processingTimeMS.toLocaleString());
          },
        }} />
      </div>
      <PoweredBy />
    </div>
    <div className="row">
      <div className="col-12 col-lg-9 order-1 order-lg-0">
        <section className="jobs-hits pt-0">
          <CustomHitComponent />
        </section>
      </div>
      <div className="col-12 col-lg-3 order-0 order-lg-1">
        <RefinementsPanel />
      </div>
    </div>
  </div>
);
