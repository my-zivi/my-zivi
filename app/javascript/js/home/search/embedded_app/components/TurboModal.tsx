import React, { FunctionComponent } from 'preact/compat';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { h } from 'preact';

const TurboFrame = (props) => h('turbo-frame', props);

const TurboModal: FunctionComponent<{ url: string, onclose: () => void }> = ({ url, onclose }) => (
  <div className="turbo-modal-wrapper" data-wrapper="true" onClick={(e) => (
    (e.target as HTMLDivElement).dataset.wrapper === 'true' && onclose()
  )}>
    <div className="container pt-5">
      <div className="row justify-content-center">
        <div className="col-12 col-lg-10">
          <div className="d-flex mt-5">
            <div className="turbo-modal-content">
              <TurboFrame src={url} id="job_posting_preview" />
            </div>
            <aside className="ml-3">
              <a
                href="#"
                className="aside-button close-button"
                onClick={(e) => {
                  e.preventDefault();
                  onclose();
                }}
                onTouchEnd={onclose}
              >
                <FontAwesomeIcon icon={['fas', 'times']} />
              </a>
            </aside>
          </div>
        </div>
      </div>
    </div>
  </div>
);

export default TurboModal;
