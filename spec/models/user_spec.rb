# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to belong_to(:referencee) }

  describe 'validations' do
    subject(:model) { described_class.new }

    it { is_expected.to validate_presence_of :email }

    describe '#email' do
      let(:valid_emails) { %w[valid@email.org a@b.c something+other@gmail.com me@subdomain.domain.co.in] }
      let(:invalid_emails) { %w[invalid @hello.com me@.ch 1234 .ch email@email@gmail.com email@invalid+domain.com] }

      it 'allows valid emails' do
        valid_emails.each do |valid_email|
          expect(model).to allow_value(valid_email).for :email
        end
      end

      it 'does not allow valid emails' do
        invalid_emails.each do |invalid_email|
          expect(model).not_to allow_value(invalid_email).for :email
        end
      end
    end
  end
end
