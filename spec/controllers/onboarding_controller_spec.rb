require 'rails_helper'

RSpec.describe OnboardingController, type: :controller do

  describe 'GET index' do
    let(:user_no_internal_id) { create(:user, internal_id: nil) }
    before { sign_in(user_no_internal_id) }

    context 'when user has no internal_id yet' do
      it 'sets current_user as @user' do
        get :index
        expect(assigns(:user)).to eq user_no_internal_id
      end

      it 'renders index template' do
        get :index
        expect(response).to render_template :index
      end
    end

    context 'when user has has already his internal_id' do
      let(:user) { create(:user) }
      before { sign_in(user) }

      it 'renders index template' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
