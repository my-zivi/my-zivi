# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Devise::LocalizedMailer do
  subject(:mailer) { Devise.mailer.reset_password_instructions(user, 'token') }

  let(:organization_member) { build(:organization_member, first_name: 'Peter', last_name: 'Müller') }
  let(:language) { 'german' }
  let(:user) { build(:user, language: language, referencee: organization_member) }

  it 'has german body' do
    expect(mailer.body.decoded).to include 'Hallo Peter Müller'
  end

  context 'when user is french' do
    let(:language) { 'french' }

    it 'has french body' do
      expect(mailer.body.decoded).to include 'Bonjour Peter Müller'
    end
  end

  context 'when user has no referencee' do
    let(:user) { build(:user, language: language) }

    it 'falls back to default salutation' do
      expect(mailer.body.decoded).to include "Hallo #{user.email}"
    end
  end
end
