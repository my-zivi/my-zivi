# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StructuredDataHelper, type: :helper do
  describe '#structured_faqs' do
    subject(:structured_faqs) { helper.structured_faqs(faqs) }

    context 'when there are faqs' do
      let(:faq) { create_list :faq, 3 }

      it { is_expected.to eq(
        {
          '@context': 'https://schema.org',
          '@type': 'FAQPage',
          mainEntity: [
            {
              '@type': 'Question',
              name: 'Question 1',
              acceptedAnswer: { '@type': 'Answer', text: 'Answer 1' }
            },
            {
              '@type': 'Question',
              name: 'Question 2',
              acceptedAnswer: { '@type': 'Answer', text: 'Answer 2' }
            },
            {
              '@type': 'Question',
              name: 'Question 3',
              acceptedAnswer: { '@type': 'Answer', text: 'Answer 3' }
            },
          ]
        }
      ) }
    end
  end
end
