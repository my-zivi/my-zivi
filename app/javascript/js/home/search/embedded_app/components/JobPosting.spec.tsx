import { shallow } from 'enzyme';
import React from 'preact/compat';
import JobPosting from './JobPosting';
import JobPostingFactory from '../../../../tests/factories/JobPostingFactory';

describe('JobPosting', () => {
  it('renders correctly', () => {
    expect(
      shallow(<JobPosting hit={JobPostingFactory.build()} />),
    ).toMatchSnapshot();
  });
});
