# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::JobPostingsController, type: :request do
  describe '#index' do
    let(:perform_request) { get(organizations_job_postings_path) }
    let(:organization) { create(:organization, :with_recruiting) }
    let(:visible_job_postings) do
      [
        create(:job_posting, organization: organization, title: 'Alp-Pflege'),
        create(:job_posting, organization: organization, title: 'Naturschutz')
      ]
    end

    let(:invisible_job_postings) do
      [
        create(:job_posting, title: 'Kinderbetreuung'),
        create(:job_posting, organization: create(:organization, :with_admin), title: 'Archivierung')
      ]
    end

    before do
      visible_job_postings
      invisible_job_postings
    end

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      before { sign_in organization_administrator.user }

      it_behaves_like 'validates presence of breadcrumbs' do
        let(:expected_breadcrumbs) do
          [I18n.t('loaf.breadcrumbs.organizations.job_postings.index')]
        end

        before { perform_request }
      end

      it 'successfully fetches a list of job postings in the organization' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response.body).to include(*visible_job_postings.map(&:title))
        expect(response.body).not_to include(*invisible_job_postings.map(&:title))
        expect(response.body).not_to include 'pagination'
      end

      context 'when content gets too long' do
        before do
          stub_const('Organizations::JobPostingsController::ITEMS', 1)
        end

        it 'paginates the response' do
          perform_request
          expect(response.body).to include 'pagination'
          expect(response.body).to include visible_job_postings.first.title
          expect(response.body).not_to include visible_job_postings.second.title
        end
      end
    end

    it_behaves_like 'recruiting subscription route only'
  end

  describe '#edit' do
    let(:perform_request) { get edit_organizations_job_posting_path(job_posting) }
    let(:organization) { create(:organization, :with_recruiting) }
    let(:job_posting) { create(:job_posting, organization: organization) }

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      let(:expected_strings) do
        [
          job_posting.title,
          job_posting.brief_description,
          job_posting.identification_number,
          I18n.t('activerecord.enums.job_posting.languages.german'),
          I18n.t('activerecord.enums.job_posting.categories.nature_conservancy'),
          I18n.t('activerecord.enums.job_posting.sub_categories.landscaping_and_gardening')
        ].map(&:to_s)
      end

      before { sign_in organization_administrator.user }

      it_behaves_like 'validates presence of breadcrumbs' do
        let(:expected_breadcrumbs) do
          [
            I18n.t('loaf.breadcrumbs.organizations.job_postings.index'),
            job_posting.title
          ]
        end

        before { perform_request }
      end

      it 'successfully displays a expense sheet form in the organization' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response.body).to include(*expected_strings)
      end
    end

    context 'when a organization administrator from another organization is signed in' do
      let(:organization_administrator) { create(:organization_member) }

      before { sign_in organization_administrator.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    it_behaves_like 'recruiting subscription route only'
  end

  describe '#update' do
    let(:perform_request) do
      patch(organizations_job_posting_path(job_posting, params: {
                                             job_posting: update_params.merge(action_text_params)
                                           }))
    end
    let(:organization) { create(:organization, :with_recruiting) }
    let(:job_posting) { create(:job_posting, organization: organization) }

    let(:update_params) do
      {
        published: true,
        identification_number: 81_709,
        title: 'Waldpflege',
        brief_description: 'Meine kurze Beschreibung',
        language: 'german',
        canton: 'LU',
        category: 'agriculture',
        sub_category: nil,
        minimum_service_months: 1,
        weekly_work_time: 45,
        fixed_work_time: true,
        good_reputation: true,
        e_government: true,
        work_on_weekend: true,
        work_night_shift: true,
        accommodation_provided: false,
        food_provided: false
      }
    end

    let(:action_text_params) do
      {
        description: 'Meine lange Beschreibung',
        required_skills: 'Alles',
        preferred_skills: 'Nichts'
      }
    end

    context 'when a organization administrator of the same organization is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      before { sign_in organization_administrator.user }

      context 'when the update params are valid' do
        it 'successfully updates the job posting' do
          expect { perform_request }.to(
            change { job_posting.reload.slice(update_params.keys) }.to(update_params)
          )
          expect(job_posting.reload.description).to be_a(ActionText::RichText)
          expect(job_posting.reload.required_skills).to be_a(ActionText::RichText)
          expect(job_posting.reload.preferred_skills).to be_a(ActionText::RichText)

          expect(response).to redirect_to(edit_organizations_job_posting_path(job_posting))
          expect(flash[:notice]).to eq I18n.t('organizations.job_postings.update.successful_update')
        end
      end

      context 'when the update params are invalid' do
        let(:update_params) { { title: '' } }

        it 'does not update' do
          expect { perform_request }.not_to(change { job_posting.reload.attributes })
          expect(response).to have_http_status(:unprocessable_entity)
          expect(flash[:error]).to eq I18n.t('organizations.job_postings.update.erroneous_update')
        end
      end
    end

    context 'when a organization administrator from another organization is signed in' do
      let(:organization_administrator) { create(:organization_member) }

      before { sign_in organization_administrator.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    it_behaves_like 'recruiting subscription route only'
  end
end
