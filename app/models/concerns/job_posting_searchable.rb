# frozen_string_literal: true

module JobPostingSearchable
  extend ActiveSupport::Concern
  include ActionView::Helpers::SanitizeHelper
  include AlgoliaSearch

  included do
    # :nocov:
    algoliasearch if: :published?, raise_on_failure: Rails.env.development?, enqueue: true do
      attributes(:title, :publication_date, :brief_description, :identification_number,
                 :contact_information, :published, :minimum_service_months,
                 :language, :featured_as_new, :priority_program)

      add_attribute :plain_description, :organization_display_name, :icon_url,
                    :category_display_name, :sub_category_display_name, :canton_display_name

      attribute :link do
        Rails.application.routes.url_helpers.job_posting_url(self, host: ENV['APP_HOST'], port: ENV['APP_PORT'])
      end

      attribute(:relevancy) { relevancy_for_database }

      attribute(:description) { description.body&.to_plain_text }
      attribute(:required_skills) { required_skills.body&.to_plain_text }
      attribute(:preferred_skills) { preferred_skills.body&.to_plain_text }

      searchableAttributes %w[
        unordered(title) organization_display_name unordered(plain_description) identification_number
      ]

      attributesForFaceting %w[
        searchable(canton_display_name) category_display_name
        priority_program sub_category_display_name
        minimum_service_months language
      ]

      customRanking %w[desc(relevancy) desc(featured_as_new)]
      attributeForDistinct 'organization_display_name'
    end
    # :nocov:

    after_save_commit :index!, if: lambda {
      !changed? && (description.changed? || required_skills.changed? || preferred_skills.changed?)
    }
  end

  def plain_description
    strip_tags(description.to_s.gsub(%r{<br ?/?>}, ' ')).squish
  end

  def organization_display_name
    return organization_name if scraped?

    organization.name
  end

  def category_display_name
    I18n.t(category, scope: 'activerecord.enums.job_posting.category_abbreviations')
  end

  def full_category_display_name
    I18n.t(category, scope: 'activerecord.enums.job_posting.categories')
  end

  def sub_category_display_name
    sub_category.presence && I18n.t(sub_category, scope: 'activerecord.enums.job_posting.sub_categories')
  end

  def canton_display_name
    I18n.t(canton, scope: 'activerecord.enums.job_posting.cantons')
  end
end
