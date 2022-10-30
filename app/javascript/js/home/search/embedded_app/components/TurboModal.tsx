import React, { FunctionComponent } from 'preact/compat';
import { h } from 'preact';

const TurboFrame = (props) => h('turbo-frame', props);

const TurboModal: FunctionComponent<{url: string; onclose: () => void; }> = ({ url, onclose, children }) => (
    <div className="turbo-modal-wrapper" data-wrapper="true" onClick={(e) => (
      (e.target as HTMLDivElement).dataset.wrapper === 'true' && onclose()
    )}>
      <div className="container pt-5">
        <div className="row justify-content-center">
          <div className="col-12 col-lg-10">
            <div className="turbo-inner-modal-wrapper d-flex mt-5">
              <div className="turbo-modal-content">
                <TurboFrame src={url} id="job_posting_preview"/>
              </div>
              {children !== undefined ? (
                <aside>
                  {children}
                </aside>
              ) : (<></>)
              }
            </div>
          </div>
        </div>
      </div>
    </div>
);

export default TurboModal;
