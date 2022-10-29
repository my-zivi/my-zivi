import React, { FunctionComponent } from 'preact/compat';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { h } from 'preact';

const TurboFrame = (props) => h('turbo-frame', props);

const TurboModal: FunctionComponent<{ title: string, url: string, onclose: () => void }> = ({ title, url, onclose }) => {
  // eslint-disable-next-line no-param-reassign
  url = url.replace('http://my-zivi.localhost:3000', 'https://myzivi-dev.thefehr.ch');

  const shareData = {
    title,
    url,
  };

  const canShare = navigator.canShare && navigator.canShare(shareData);

  const share = (e) => {
    e.preventDefault();
    navigator.share(shareData);
  };

  return (
    <div className="turbo-modal-wrapper" data-wrapper="true" onClick={(e) => (
      (e.target as HTMLDivElement).dataset.wrapper === 'true' && onclose()
    )}>
      <div className="container pt-5">
        <div className="row justify-content-center">
          <div className="col-12 col-lg-10">
            <div className="turbo-inner-modal-wrapper d-flex mt-5">
              <div className="turbo-modal-content">
                <TurboFrame src={`${url}/preview`} id="job_posting_preview"/>
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
                  <FontAwesomeIcon icon={['fas', 'times']}/>
                </a>
                { canShare ? (
                  <a
                    href="#"
                    className="aside-button sharing-button"
                    onClick={share}
                    onTouchEnd={share}
                  >
                    <FontAwesomeIcon icon={['fas', 'share']}/>
                  </a>
                ) : (
                  <a
                    href={url}
                    target="_blank"
                    className="aside-button open-button"
                    >
                    Open
                  </a>
                )}
              </aside>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TurboModal;
