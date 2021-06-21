import * as _ from 'lodash';
import Factory from 'js/tests/factories/Factory';
import { JobPostingSearchHit, Relevancy } from 'js/home/search/embedded_app/types';

const JobPostingFactory: Factory<JobPostingSearchHit> = {
  build(overrides?: Record<string, unknown> | JobPostingSearchHit): JobPostingSearchHit {
    const defaultJobPostingSearchHit: JobPostingSearchHit = {
      objectID: 1,
      title: 'Alp-Pflege',
      icon_url: '/myzivi-logo.jpg',
      publication_date: '2020-01-06',
      plain_description: 'Alp-Pflege...',
      description: '<b>Hausinternes Bestellwesen</b> wie z. B. Lebensmittel bestellen, Essensbestellungen',
      brief_description: '100% Dauer Alpsommer: von 01.05. bis 15.10.Bereich Kulturlandschaft',
      required_skills: 'Motivation und physische Kondition für harte körperliche Arbeit im Freien.',
      preferred_skills: 'Erfahrung im Bau von Trockenmauern',
      canton: 'OW',
      identification_number: '89372',
      relevancy: Relevancy.Normal,
      contact_information: '',
      minimum_service_months: 1,
      language: 'german',
      organization_display_name: 'Alpbetrieb Untersteiglen-Schwand',
      category_display_name: 'Landwirtschaft',
      sub_category_display_name: undefined,
      link: 'http://example.com/job_postings/1',
      featured_as_new: false,
      priority_program: false,
    };

    return _.merge(defaultJobPostingSearchHit, overrides);
  },
};

export default JobPostingFactory;
