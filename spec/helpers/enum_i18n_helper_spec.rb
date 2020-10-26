# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnumI18nHelper, type: :helper do

  describe '#enum_options_for_select' do
    subject { helper.enum_options_for_select(Service, :service_types) }

    let(:expected_options) do
      [
        [ t('activerecord.enums.service.service_types.normal'), 'normal' ],
        [ t('activerecord.enums.service.service_types.long'), 'long' ],
        [ t('activerecord.enums.service.service_types.probation'), 'probation' ]
      ]
    end

    it { is_expected.to eq expected_options }
  end

  describe '#enum_l' do
    subject { helper.enum_l(model, :service_type) }

    let(:model) { build :service, :long }

    it { is_expected.to eq t('activerecord.enums.service.service_types.long') }
  end

  describe '#enum_i18n' do
    subject { helper.enum_i18n(Service, :service_types, :long) }

    it { is_expected.to eq t('activerecord.enums.service.service_types.long') }
  end
end
