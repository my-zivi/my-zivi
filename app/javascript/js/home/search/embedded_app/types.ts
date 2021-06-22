/* eslint-disable camelcase */

export interface JobPostingSearchHit {
  objectID: string;
  title: string;
  icon_url: string;
  publication_date: string;
  plain_description: string;
  description: string;
  brief_description: string;
  required_skills?: string;
  preferred_skills?: string;
  canton: string;
  identification_number: string;
  relevancy: Relevancy;
  contact_information: string;
  minimum_service_months: number;
  language: string;
  organization_display_name: string;
  category_display_name: string;
  sub_category_display_name?: string;
  link: string;
  featured_as_new: boolean;
  priority_program: boolean;
}

export enum Relevancy {
  Normal = 1,
  Urgent,
  Featured
}
