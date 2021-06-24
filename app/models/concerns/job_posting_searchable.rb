# frozen_string_literal: true

module JobPostingSearchable
  extend ActiveSupport::Concern
  include AlgoliaSearch

  included do
    # :nocov:
    algoliasearch if: :published?, raise_on_failure: Rails.env.development?, enqueue: true do
      attributes(:title, :icon_url, :publication_date, :description,
                 :brief_description, :required_skills, :preferred_skills,
                 :identification_number, :contact_information, :published,
                 :minimum_service_months, :language, :featured_as_new, :priority_program)

      add_attribute :plain_description, :organization_display_name,
                    :category_display_name, :sub_category_display_name, :canton_display_name

      attribute :link do
        Rails.application.routes.url_helpers.job_posting_url(self, host: ENV['APP_HOST'], port: ENV['APP_PORT'])
      end

      attribute :relevancy do
        relevancy_for_database
      end

      searchableAttributes %w[unordered(title) organization_display_name unordered(plain_description)]
      attributesForFaceting %w[
        searchable(canton_display_name) category_display_name
        priority_program sub_category_display_name
        minimum_service_months language
      ]

      customRanking %w[desc(relevancy) desc(featured_as_new)]
      attributeForDistinct 'organization_display_name'
    end
    # :nocov:
  end

  def plain_description
    strip_tags(description).squish
  end

  def organization_display_name
    return organization_name if scraped?

    organization.name
  end

  def category_display_name
    I18n.t(category, scope: 'activerecord.enums.job_postings.category')
  end

  def sub_category_display_name
    sub_category.presence && I18n.t(sub_category, scope: 'activerecord.enums.job_postings.sub_category')
  end

  def canton_display_name
    I18n.t(canton, scope: 'activerecord.enums.job_postings.canton')
  end
end