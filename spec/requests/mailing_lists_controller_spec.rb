# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MailingListsController, type: :request do
  describe '#create' do
    let(:perform_request) { post mailing_list_path, params: { mailing_list: mailing_list_params } }
    let(:mailing_list_params) do
      {
        name: 'Lucy Hopcraft',
        organization: 'MyZivi AG',
        email: 'lucy@example.com',
        telephone: '0798921234'
      }.with_indifferent_access
    end

    let(:created_mailing_list_entry) { MailingList.order(:created_at).last }

    it 'creates mailing list inquiry and returns a successful response' do
      expect { perform_request }.to(change(MailingList, :count))
      expect(created_mailing_list_entry.slice(mailing_list_params.keys)).to eq mailing_list_params
      expect(response).to redirect_to root_path(anchor: 'mailing-list')
      follow_redirect!
      # TODO: Add mailing list back
      # expect(response.body).to include I18n.t('mailing_list.successful_creation')
    end

    context 'when params are invalid' do
      let(:mailing_list_params) do
        {
          name: '',
          organization: 'MyZivi AG',
          email: '',
          telephone: '0798921234'
        }
      end

      it 'does not create a mailing list inquiry and returns an error message' do
        expect { perform_request }.not_to change(MailingList, :count)
        expect(response).to render_template 'home/index'
        # expect(response.body).to include I18n.t('mailing_list.erroneous_creation')
      end
    end
  end
end
