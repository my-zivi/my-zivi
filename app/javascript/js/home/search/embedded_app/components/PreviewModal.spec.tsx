import React from 'preact/compat';
import JobPostingFactory from '../../../../tests/factories/JobPostingFactory';
import { mountInstantSearchClient } from '../../../../../../../jest/utils';
import PreviewModal from './PreviewModal';

const noop = () => null;

describe('JobPosting', () => {
  let rendered;

  beforeEach(() => {
    rendered = mountInstantSearchClient(
      <PreviewModal hit={JobPostingFactory.build() as never} onclose={noop} />,
    );
  });

  it('renders correctly', () => {
    const jobPostingComponent = rendered.find('PreviewModal').children();
    expect(jobPostingComponent).toMatchSnapshot();
  });
});
