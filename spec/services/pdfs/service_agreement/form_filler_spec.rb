# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pdfs::ServiceAgreement::FormFiller, type: :service do
  describe '#render' do
    let(:pdf) { described_class.render(render_data, template_path) }
    let(:render_data) do
      Pdfs::ServiceAgreement::DataProvider.evaluate_data_hash(
        Pdfs::ServiceAgreement::GermanFormFields::SERVICE_AGREEMENT_FIELDS,
        service: service
      )
    end
    let(:template_path) { Rails.root.join('lib/assets/pdfs/german_service_agreement_form.pdf').to_s }
    let(:service) { create :service, service_data.merge(service_data) }
    let(:civil_servant) { service.civil_servant }
    let(:service_data) { { beginning: '2018-12-10', ending: '2019-01-18' } }

    let(:pdf_page_inspector) { PDF::Inspector::Page.analyze(pdf) }

    context 'when is german' do
      it 'renders something' do
        expect(pdf).not_to be_nil
        expect(pdf_page_inspector.pages.size).to eq 2
      end
    end
  end
end
