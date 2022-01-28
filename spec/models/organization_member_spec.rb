# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationMember, type: :model do
  describe 'model definition' do
    subject(:model) { described_class.new }

    # rubocop:disable RSpec/ExampleLength
    it 'defines relations' do
      expect(model).to belong_to(:organization)
      expect(model).to(
        have_many(:service_specification_contacts)
          .class_name('ServiceSpecification')
          .inverse_of(:contact_person)
          .dependent(:restrict_with_exception)
      )
      expect(model).to(
        have_many(:service_specification_leads)
          .class_name('ServiceSpecification')
          .inverse_of(:lead_person)
          .dependent(:restrict_with_exception)
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe 'validation' do
    subject(:model) { described_class.new }

    it_behaves_like 'validates presence of required fields', %i[first_name last_name phone organization_role email]
  end
end
