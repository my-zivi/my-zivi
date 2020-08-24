# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/civil_servants/index.html.slim', type: :view do
  subject { rendered }

  let(:show_inactive) { true }
  let(:civil_servants) do
    [
      build(:civil_servant, first_name: 'Peter', last_name: 'Black', id: 1),
      build(:civil_servant, first_name: 'Cordula', last_name: 'Grün', id: 2)
    ]
  end

  before do
    assign(:civil_servants, civil_servants)
    assign(:filters, { show_inactive: show_inactive })
    render
  end

  it 'renders list of civil servants' do
    expect(rendered).to include '(2)'
    expect(rendered).to include 'Peter Black', 'PB', organizations_civil_servant_path(1)
    expect(rendered).to include 'Cordula Grün', 'CG', organizations_civil_servant_path(2)

    assert_select 'input[id=?][checked]', 'hide-past-services'
  end

  context 'when show inactive is false' do
    let(:show_inactive) { false }

    it 'renders unchecked input field' do
      assert_select 'input[id=?]:not([checked])', 'hide-past-services'
    end
  end
end
