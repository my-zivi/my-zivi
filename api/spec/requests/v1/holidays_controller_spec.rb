# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::HolidaysController, type: :request do
  context 'when the user is signed in' do
    let(:user) { create :user }

    before { sign_in user }

    describe '#index' do
      it_behaves_like 'renders a successful http status code' do
        before { create :holiday }

        let(:request) { get v1_holidays_path }
      end
    end

    describe '#create' do
      subject { -> { post_request } }

      let(:post_request) { post v1_holidays_path(holiday: params) }

      context 'when params are valid' do
        let(:params) { attributes_for(:holiday) }

        it_behaves_like 'renders a successful http status code' do
          let(:request) { post_request }
        end

        it { is_expected.to change(Holiday, :count).by(1) }

        it 'returns the created holiday' do
          post_request
          expect(parse_response_json(response)).to include(
            id: Holiday.last.id,
            beginning: params[:beginning],
            ending: params[:ending],
            holiday_type: params[:holiday_type].to_s,
            description: params[:description]
          )
        end
      end

      context 'when params are invalid' do
        let(:params) { { description: '', ending: 'I am invalid' } }

        it { is_expected.to change(Holiday, :count).by(0) }

        it_behaves_like 'renders a validation error response' do
          let(:request) { post_request }
        end

        it 'renders all validation errors' do
          post_request
          expect(parse_response_json(response)[:errors]).to include(
            ending: be_an_instance_of(Array),
            beginning: be_an_instance_of(Array),
            description: be_an_instance_of(Array)
          )
        end
      end
    end

    describe '#update' do
      let!(:holiday) { create :holiday }
      let(:put_request) { put v1_holiday_path(holiday, params: { holiday: params }) }

      context 'with valid params' do
        subject { -> { put_request } }

        let(:params) { { description: 'New description' } }
        let(:expected_attributes) { extract_to_json(holiday, :beginning, :ending, :description, :holiday_type, :id) }

        it { is_expected.to(change { holiday.reload.description }.to('New description')) }

        it_behaves_like 'renders a successful http status code' do
          let(:request) { put_request }
        end

        it 'returns the updated holiday' do
          put_request
          expect(parse_response_json(response)).to include(expected_attributes)
        end
      end

      context 'with invalid params' do
        let(:params) { { description: '' } }

        it_behaves_like 'renders a validation error response' do
          let(:request) { put_request }
        end

        it 'renders all validation errors' do
          put_request
          expect(parse_response_json(response)[:errors]).to include(
            description: be_an_instance_of(Array)
          )
        end
      end

      context 'when the requested resource does not exist' do
        it_behaves_like 'renders a not found error response' do
          let(:request) { put v1_holiday_path(-2) }
        end
      end
    end

    describe '#destroy' do
      subject { -> { delete_request } }

      let!(:holiday) { create :holiday }
      let(:delete_request) { delete v1_holiday_path(holiday) }

      it { is_expected.to change(Holiday, :count).by(-1) }

      it 'returns the deleted resource' do
        expected_response = extract_to_json(holiday, :id, :beginning, :ending, :description)

        delete_request

        expect(parse_response_json(response)).to include(expected_response)
      end

      context 'when the requested resource does not exist' do
        let(:request) { delete v1_holiday_path(-2) }

        it_behaves_like 'renders a not found error response'

        it 'does not delete anything' do
          expect { request }.not_to change(Holiday, :count)
        end
      end
    end
  end

  context 'when no user is signed in' do
    describe '#index' do
      it_behaves_like 'login protected resource' do
        let(:request) { get v1_holidays_path }
      end
    end

    describe '#create' do
      let(:params) { attributes_for(:holiday) }
      let(:request) { post v1_holidays_path(holiday: params) }

      it_behaves_like 'login protected resource'

      it 'does not create a new holiday' do
        expect { request }.not_to change(Holiday, :count)
      end
    end

    describe '#update' do
      let!(:holiday) { create :holiday }
      let(:request) { put v1_holiday_path(holiday, params: { holiday: params }) }
      let(:params) { { description: 'New description' } }

      it_behaves_like 'login protected resource'

      it 'does not update the holiday' do
        expect { request }.not_to(change { holiday.reload.description })
      end
    end

    describe '#destroy' do
      let!(:holiday) { create :holiday }
      let(:request) { delete v1_holiday_path(holiday) }

      it_behaves_like 'login protected resource'

      it 'does not delete the holiday' do
        expect { request }.not_to change(Holiday, :count)
      end
    end
  end
end
