import React from 'preact/compat';
import JobPosting from './JobPosting';
import JobPostingFactory from '../../../../tests/factories/JobPostingFactory';
import { mountInstantSearchClient } from '../../../../../../../jest/utils';

describe('JobPosting', () => {
  let rendered;

  beforeEach(() => {
    rendered = mountInstantSearchClient(
      <JobPosting hit={JobPostingFactory.build() as never} />,
    );
  });

  it('renders correctly', () => {
    const jobPostingComponent = rendered.find('JobPosting');
    expect(jobPostingComponent).toMatchSnapshot();
  });
});
