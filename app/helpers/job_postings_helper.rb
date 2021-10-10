# frozen_string_literal: true

module JobPostingsHelper
  def job_posting_category_icon(job_posting)
    klass = {
      nature_conservancy: 'fas fa-leaf',
      healthcare: 'fas fa-star-of-life',
      social_welfare: 'fas fa-wheelchair',
      disaster_relief: 'fas fa-biohazard',
      education: 'fas fa-school',
      preservation_of_cultural_assets: 'fas fa-book-open',
      agriculture: 'fas fa-tractor',
      development_cooperation: 'fas fa-hands-helping'
    }.fetch(job_posting.category.to_sym)

    tag.i(class: "#{klass} mr-1")
  end

  def google_maps_link(job_posting)
    link_to(google_maps_url(job_posting), target: '_blank', rel: 'noreferrer nofollow noopener') do
      tag.div(class: 'd-inline-flex') do
        concat job_posting.organization_display_name
        concat tag.i(class: 'fas fa-external-link-alt ml-1')
      end
    end
  end

  private

  def google_maps_url(job_posting)
    "https://www.google.com/maps/search/?api=1&query=#{job_posting.address.latitude},#{job_posting.address.longitude}"
  end
end
