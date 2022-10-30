import React, { FunctionComponent } from 'preact/compat';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import TurboModal from 'js/home/search/embedded_app/components/TurboModal';
import { JobPostingSearchHit } from 'js/home/search/embedded_app/types';

interface PreviewModalProps {
  hit: JobPostingSearchHit;
  onclose: () => void;
}

const PreviewModal: FunctionComponent<PreviewModalProps> = ({
  hit, onclose,
}) => {
  // eslint-disable-next-line no-param-reassign
  const url = hit.link;

  const shareData = {
    title: hit.title,
    url,
  };

  const canShare = navigator.canShare && navigator.canShare(shareData);

  const share = (e) => {
    e.preventDefault();
    navigator.share(shareData);
  };

  return (
    <TurboModal
      url={`${url}/preview`}
      onclose={onclose}
      >
      <a
        href="#"
        className="aside-button close-button"
        onClick={(e) => {
          e.preventDefault();
          e.stopPropagation();
          onclose();
        }}
        onTouchEnd={(e) => {
          e.preventDefault();
          e.stopPropagation();
          onclose();
        }}
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
          <FontAwesomeIcon icon={['fas', 'share-alt']} title={'TODO'}/>
        </a>
      ) : (
        <a
          href={url}
          target="_blank"
          className="aside-button open-button"
        >
          <FontAwesomeIcon icon={['fas', 'external-link-alt']}/>
        </a>
      )}
    </TurboModal>
  );
};

export default PreviewModal;
