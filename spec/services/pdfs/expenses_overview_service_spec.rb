# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pdfs::ExpensesOverviewService, type: :service do
  let(:pdf) do
    described_class.new(
      create_pair(:service_specification),
      OpenStruct.new(
        beginning: Date.parse('2020-01-01'),
        ending: Date.parse('2020-12-31')
      )
    )
  end

  it 'renders something' do
    expect(pdf).not_to be_nil
  end
end
