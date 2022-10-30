/* eslint-disable quote-props */
import { Requester, Response } from '@algolia/requester-common';
import algoliasearch from 'algoliasearch';

const content = {
  results: [
    {
      hits: [
        {
          title: 'Alp-Pflege',
          icon_url: '/myzivi-logo.jpg',
          publication_date: '2021-06-14',
          description: 'MyDescription <b>Using HTML</b>',
          brief_description: 'Bereich Kulturlandschaft, Biodiversität und Landschaftsqualität',
          required_skills: '<p> Motivation und physische Kondition für harte körperliche Arbeit im Freien</p>',
          preferred_skills: null,
          identification_number: 89372,
          contact_information: 'Dieser Betrieb ist noch nicht bei MyZivi registriert. Bitte bewerbe Dich im EZIVI.',
          published: true,
          minimum_service_months: 1,
          language: 'german',
          featured_as_new: true,
          priority_program: true,
          link: 'http://localhost:3000/job_postings/3',
          relevancy: 1,
          plain_description: '100% Dauer Alpsommer: von 01.05. bis 15.10',
          organization_display_name: 'Alpbetrieb Untersteiglen-Schwand im Tal-Melchsee-Frutt',
          category_display_name: 'Landwirtschaft',
          sub_category_display_name: null,
          canton_display_name: 'Obwalden',
          objectID: '3',
          _highlightResult: {
            title: {
              value: '<ais-highlight-0000000000>Al</ais-highlight-0000000000>p-Pflege',
              matchLevel: 'full',
              fullyHighlighted: false,
              matchedWords: [
                'al',
              ],
            },
            plain_description: {
              value: '100% Dauer <ais-highlight-0000000000>Al</ais-highlight-0000000000>psommer',
              matchLevel: 'full',
              fullyHighlighted: false,
              matchedWords: [
                'al',
              ],
            },
            organization_display_name: {
              value: '<ais-highlight-0000000000>Al</ais-highlight-0000000000>',
              matchLevel: 'full',
              fullyHighlighted: false,
              matchedWords: [
                'al',
              ],
            },
          },
        },
      ],
      nbHits: 10,
      page: 0,
      nbPages: 1,
      hitsPerPage: 20,
      facets: {
        language: { german: 10 },
        priority_program: {
          true: 9,
          false: 1,
        },
        canton_display_name: {
          Luzern: 3,
          Obwalden: 2,
          Zug: 2,
          'Graubünden': 1,
          Schwyz: 1,
          'St. Gallen': 1,
        },
        category_display_name: {
          Sozialwesen: 5,
          Gesundheitswesen: 2,
          Landwirtschaft: 2,
          'Entwicklungszusammenarbeit und humanitäre Hilfe': 1,
        },
        minimum_service_months: {
          1: 5,
          4: 3,
          2: 1,
          3: 1,
        },
      },
      facets_stats: {
        minimum_service_months: {
          min: 1,
          max: 4,
          avg: 2,
          sum: 22,
        },
      },
      exhaustiveFacetsCount: true,
      exhaustiveNbHits: true,
      query: 'al',
      params: 'highlightPreTag=%3Cais-highlight-0000000000%3E&highlightPostTag=%3C%2Fais-highlight-0000000000%3E&',
      index: 'JobPosting',
      processingTimeMS: 2,
    },
  ],
};

export const mockRequester: Requester = {
  send(): Readonly<Promise<Response>> {
    return Promise.resolve(
      {
        content: JSON.stringify(content),
        isTimedOut: false,
        status: 200,
      },
    );
  },
};

export const mockClient = algoliasearch('appid', 'apikey', {
  requester: mockRequester,
  hosts: [
    {
      url: 'example.com',
      accept: 3,
      protocol: 'http',
    },
  ],
});
