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
end
