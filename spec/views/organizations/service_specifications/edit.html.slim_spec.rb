# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizations/service_specifications/edit', type: :view do
  let(:service_specification) { create(:service_specification) }
  let(:current_organization_admin) { build(:organization_member) }

  let(:expected_input_names) do
    %i[
      name internal_note work_clothing_expenses
      accommodation_expenses location active identification_number
    ]
  end

  let(:expected_expense_fields) do
    %i[work_days_expenses paid_vacation_expenses first_day_expenses last_day_expenses]
  end

  before do
    assign(:service_specification, service_specification)
    allow(view).to receive(:current_organization_admin).and_return current_organization_admin
    render
  end

  it 'renders the edit text based input fields' do
    assert_select 'form[action=?][method=?]', organizations_service_specification_path(service_specification), 'post' do
      expected_input_names.each do |name|
        assert_select 'input[name=?]', "service_specification[#{name}]"
      end
    end
  end

  it 'renders organization member relation fields' do
    assert_select 'select[name=?]', 'service_specification[contact_person_id]'
    assert_select 'select[name=?]', 'service_specification[lead_person_id]'
  end

  it 'renders expense fields' do
    expected_expense_fields.each do |name|
      assert_select 'input[name=?]', "service_specification[#{name}][breakfast]"
      assert_select 'input[name=?]', "service_specification[#{name}][lunch]"
      assert_select 'input[name=?]', "service_specification[#{name}][dinner]"
    end
  end
end
