# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServicesSerializer do
  def parse_response(response)
    JSON.parse(response, symbolize_names: true)
  end

  describe '.call' do
    subject(:parsed_json) { parse_response(described_class.call([first_service, second_service])) }

    let(:civil_servant) { build(:civil_servant, :full, first_name: 'Happy', last_name: 'Freeman') }
    let(:first_service) { build(:service, beginning: '2020-01-06', ending: '2020-02-07', civil_servant: civil_servant) }
    let(:second_service) { build(:service, beginning: '2020-03-02', ending: '2020-04-03') }

    let(:serialized_first_service) do
      {
        beginning: '2020-01-06',
        ending: '2020-02-07',
        civilServant: {
          id: anything,
          fullName: 'Happy Freeman'
        }
      }
    end

    let(:serialized_second_service) do
      {
        beginning: '2020-03-02',
        ending: '2020-04-03',
        civilServant: {
          id: anything,
          fullName: 'Zivi Mustermann'
        }
      }
    end

    it 'returns the correct serialized JSON' do
      expect(parsed_json).to contain_exactly(serialized_first_service, serialized_second_service)
    end

    context 'when passed services are empty' do
      subject(:parsed_json) { parse_response(described_class.call([])) }

      it { is_expected.to be_an(Array).and(be_empty) }
    end
  end
end
