class JobPostingHtmlContentToActionText < ActiveRecord::Migration[6.1]
include ActionView::Helpers::TextHelper

  def up
    rename_column :job_postings, :description, :description_old
    rename_column :job_postings, :required_skills, :required_skills_old
    rename_column :job_postings, :preferred_skills, :preferred_skills_old

    JobPosting.without_auto_index do
      JobPosting.all.each do |job_posting|
        job_posting.update_attribute(:description, simple_format(job_posting.description_old))
        job_posting.update_attribute(:required_skills, simple_format(job_posting.required_skills_old))
        job_posting.update_attribute(:preferred_skills, simple_format(job_posting.preferred_skills_old))
      end
    end

    remove_column :job_postings, :description_old
    remove_column :job_postings, :required_skills_old
    remove_column :job_postings, :preferred_skills_old
  end
end
