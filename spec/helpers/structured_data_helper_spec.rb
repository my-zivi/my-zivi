# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StructuredDataHelper, type: :helper do
  describe '#structured_faqs' do
    subject(:structured_faqs) { helper.structured_faqs(faqs) }

    context 'when there are faqs' do
      let(:faqs) { create_list :faq, 3 }
      let(:expected_hash) do
        {
          '@context': 'https://schema.org',
          '@type': 'FAQPage',
          mainEntity: [
            {
              '@type': 'Question',
              name: faqs.first.question,
              acceptedAnswer: { '@type': 'Answer', text: faqs.first.answer }
            },
            {
              '@type': 'Question',
              name: faqs.second.question,
              acceptedAnswer: { '@type': 'Answer', text: faqs.second.answer }
            },
            {
              '@type': 'Question',
              name: faqs.third.question,
              acceptedAnswer: { '@type': 'Answer', text: faqs.third.answer }
            }
          ]
        }
      end

      it {
        expect(structured_faqs).to eq expected_hash
      }
    end
  end
end
