# frozen_string_literal: true

RSpec.shared_examples_for 'recruiting subscription route only' do |skip_civil_servant_check: false|
  context 'when not subscribed to recruiting ability' do
    let(:organization) { create(:organization, :with_admin) }
    let(:organization_member) { create(:organization_member, organization: organization) }

    before do
      perform_request
      sign_in organization_member.user
    end

    it_behaves_like 'unauthenticated request'
  end

  it_behaves_like 'organization route only', skip_civil_servant_check: skip_civil_servant_check
end

RSpec.shared_examples_for 'admin subscription route only' do |skip_civil_servant_check: false|
  context 'when not subscribed to admin ability' do
    let(:organization) { create(:organization, :with_recruiting) }
    let(:organization_member) { create(:organization_member, organization: organization) }

    before do
      perform_request
      sign_in organization_member.user
    end

    it_behaves_like 'unauthenticated request'
  end

  it_behaves_like 'organization route only', skip_civil_servant_check: skip_civil_servant_check
end

RSpec.shared_examples_for 'organization route only' do |skip_civil_servant_check: false|
  unless skip_civil_servant_check
    context 'when a civil servant is signed in' do
      before { sign_in create(:civil_servant, :full).user }

      it_behaves_like 'unauthorized request' do
        before { perform_request }
      end
    end
  end

  context 'when no one is signed in' do
    before { perform_request }

    it_behaves_like 'unauthenticated request'
  end
end

RSpec.shared_examples_for 'admin subscription json route only' do
  context 'when not subscribed to admin ability' do
    let(:organization) { create(:organization, :with_recruiting) }
    let(:organization_member) { create(:organization_member, organization: organization) }

    before do
      sign_in organization_member.user
      perform_request
    end

    it_behaves_like 'unauthorized json request'
  end

  it_behaves_like 'organization json route only'
end

RSpec.shared_examples_for 'organization json route only' do
  context 'when a civil servant is signed in' do
    before do
      sign_in create(:civil_servant, :full).user
      perform_request
    end

    it_behaves_like 'unauthorized json request'
  end

  context 'when nobody is signed in' do
    it_behaves_like 'unauthenticated json request' do
      before { perform_request }
    end
  end
end
