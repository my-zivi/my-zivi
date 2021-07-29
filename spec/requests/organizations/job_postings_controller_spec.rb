# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::JobPostingsController, type: :request do
  describe '#index' do
    let(:perform_request) { get(organizations_job_postings_path) }
    let(:organization) { create(:organization, :with_recruiting) }
    let(:visible_job_posting) { create(:job_posting, organization: organization, title: 'Naturschutz') }
    let(:invisible_job_postings) do
      [
        create(:job_posting, title: 'Pflege'),
        create(:job_posting, organization: create(:organization, :with_admin), title: 'Archivierung')
      ]
    end

    before do
      visible_job_posting
      invisible_job_postings
    end

    context 'when a organization administrator is signed in' do
      let(:organization_administrator) { create(:organization_member, organization: organization) }

      before { sign_in organization_administrator.user }

      it 'successfully fetches a list of job postings in the organization' do
        perform_request
        expect(response).to have_http_status(:success)
        expect(response.body).to include visible_job_posting.title
        expect(response.body).not_to include(*invisible_job_postings.map(&:title))
      end
    end

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create(:civil_servant, :full) }

      before { sign_in civil_servant.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    context 'when nobody is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
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

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create(:civil_servant, :full) }

      before { sign_in civil_servant.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    context 'when nobody is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
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
        minimum_service_months: 1
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
          expect(response).to have_http_status(:success)
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

    context 'when a civil servant is signed in' do
      let(:civil_servant) { create(:civil_servant, :full) }

      before { sign_in civil_servant.user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end

    context 'when nobody is signed in' do
      before { perform_request }

      it_behaves_like 'unauthenticated request'
    end
  end
end
