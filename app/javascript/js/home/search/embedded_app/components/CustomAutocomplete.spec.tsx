import React from 'preact/compat';
import { Hit } from 'react-instantsearch-core';
import { mount } from 'enzyme';
import { deferredCheck, mountInstantSearchClient } from '../../../../../../../jest/utils';
import CustomAutocomplete, { AutocompleteImpl } from './CustomAutocomplete';
import JobPostingFactory from '../../../../tests/factories/JobPostingFactory';
import { JobPostingSearchHit } from '../types';

describe('CustomAutocomplete', () => {
  let root;

  beforeEach(() => {
    root = mountInstantSearchClient(<CustomAutocomplete defaultRefinement="alp" />);
  });

  it('renders correctly', () => deferredCheck(root, () => {
    const rendered = root.find('AutocompleteImpl');
    expect(rendered).toMatchSnapshot();
  }));

  it('renders an autocomplete menu when focusing input element', () => deferredCheck(root, () => {
    const inputElement = root.find('input[type="search"]');
    inputElement.simulate('focus');

    expect(root.find('AutocompleteImpl')).toMatchSnapshot();
  }));

  it('collapses autocomplete when mouse moves out and input blurred', () => deferredCheck(root, () => {
    const inputElement = root.find('input[type="search"]');
    inputElement.simulate('focus');
    root.find('.autocomplete-content').simulate('mouseenter');

    const autocompleteContainerClassName = () => root.find('.autocomplete-container').props().className;
    expect(autocompleteContainerClassName()).toMatch(/d-block/);

    inputElement.simulate('blur');
    expect(autocompleteContainerClassName()).toMatch(/d-block/);

    root.find('.autocomplete-content').simulate('mouseleave');
    expect(autocompleteContainerClassName()).toMatch(/d-none/);
  }));

  it('collapses autocomplete touch mouse ends and input blurred', () => deferredCheck(root, () => {
    const inputElement = root.find('input[type="search"]');
    inputElement.simulate('focus');
    root.find('.autocomplete-content').simulate('touchstart');
    expect(root.find('.autocomplete-container').props().className).toMatch(/d-block/);

    inputElement.simulate('blur');
    expect(root.find('.autocomplete-container').props().className).toMatch(/d-block/);

    root.find('.autocomplete-content').simulate('touchend');
    expect(root.find('.autocomplete-container').props().className).toMatch(/d-none/);
  }));

  describe('when a user clicks on an autocomplete item', () => {
    const refine = jest.fn();

    it('searches for the given term', () => {
      const hits = [{
        objectID: '123',
        ...JobPostingFactory.build({ title: 'Mitarbeiter Jugendhilfe' }),
      } as Hit<JobPostingSearchHit>];
      root = mount(<AutocompleteImpl refine={refine} hits={hits} currentRefinement="" />);
      root.setProps({ currentRefinement: 'Mitarbeiter' });

      root.find('.autocomplete-content').simulate('mouseenter');
      root.find('.autocomplete-hit').simulate('click');
      expect(refine).toHaveBeenCalledWith('Mitarbeiter Jugendhilfe');
    });
  });

  describe('when the user presses the enter key', () => {
    const refine = jest.fn();

    it('searches for the selected term', () => deferredCheck(root, () => {
      const hits = [{
        objectID: '123',
        ...JobPostingFactory.build({ title: 'Mitarbeiter Jugendhilfe' }),
      } as Hit<JobPostingSearchHit>];
      root = mount(<AutocompleteImpl refine={refine} hits={hits} currentRefinement="" />);
      root.setProps({ currentRefinement: 'Mitarbeiter' });
      root.update();

      document.dispatchEvent(new KeyboardEvent('keyup', { key: 'arrowdown', keyCode: 40 }));
      document.dispatchEvent(new KeyboardEvent('keyup', { key: 'enter', keyCode: 13 }));
      root.update();

      expect(refine).toHaveBeenCalledWith('Mitarbeiter Jugendhilfe');
    }));
  });
});
