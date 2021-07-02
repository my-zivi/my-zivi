import { shallow } from 'enzyme';
import React from 'preact/compat';
import Ribbon from './Ribbon';
import JobPostingFactory from '../../../../tests/factories/JobPostingFactory';
import { Relevancy } from '../types';

describe('Ribbon', () => {
  it('renders correctly', () => {
    expect(
      shallow(<Ribbon hit={JobPostingFactory.build()} />),
    ).toMatchSnapshot();
  });

  describe('when job posting is new', () => {
    expect(
      shallow(<Ribbon hit={JobPostingFactory.build({ featured_as_new: true })} />),
    ).toMatchSnapshot();
  });

  describe('when job posting is urgent', () => {
    expect(
      shallow(<Ribbon hit={JobPostingFactory.build({ relevancy: Relevancy.Urgent })} />),
    ).toMatchSnapshot();
  });

  describe('when job posting is featured', () => {
    expect(
      shallow(<Ribbon hit={JobPostingFactory.build({ relevancy: Relevancy.Featured })} />),
    ).toMatchSnapshot();
  });
});
