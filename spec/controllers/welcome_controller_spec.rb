require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do

  let!(:user) { create(:user_with_profile_picture, role: 'basic') }
  let!(:user_test) { create(:user_with_profile_picture, role: 'test_only') }

  describe 'index #GET' do

    context 'with a connected basic user' do
      before do
        sign_in user
      end

      let!(:user_admin) { create(:user_with_profile_picture, role: 'admin') }
      let!(:user_no_picture) { create(:user) }

      it 'redirects to root' do
        get :index
        expect(response).to render_template "index"
      end

      it 'returns users with image profile ONLY and people scope' do
        get :index
        expect(assigns[:users]).to match_array([user, user_admin])
      end
    end

    context 'with a not connected user' do
      it 'redirects to root' do
        get :index
        expect(response).to render_template "index"
      end

      it 'returns users with image profile ONLY and people scope' do
        get :index
        expect(assigns[:users]).to match_array([])
      end
    end

    context 'with a connected test user' do
      before do
        sign_in user_test
      end

      it 'redirects to root' do
        get :index
        expect(response).to render_template "index"
      end

      it 'returns users with image profile ONLY and people scope' do
        get :index
        expect(assigns[:users]).to match_array([user_test])
      end
    end

  end

end
