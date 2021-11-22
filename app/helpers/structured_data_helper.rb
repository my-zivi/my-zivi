# frozen_string_literal: true

module StructuredDataHelper
  def structured_faqs(faqs)
    {
      '@context': 'https://schema.org',
      '@type': 'FAQPage',
      mainEntity: faqs.map do |faq|
        {
          '@type': 'Question',
          name: faq.question,
          acceptedAnswer: { '@type': 'Answer', text: faq.answer }
        }
      end
    }
  end
end
