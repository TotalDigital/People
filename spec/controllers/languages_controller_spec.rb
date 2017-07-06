require 'rails_helper'

RSpec.describe LanguagesController, type: :controller do

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "create #POST" do
    it "creates a new language" do
      expect { post :create, user_id: user.id, language: attributes_for(:language) }.to change(Language, :count).by 1
    end

    it "creates a new user_language" do
      expect { post :create, user_id: user.id, language: attributes_for(:language) }.to change(UsersLanguage, :count).by 1
    end

    it "redirects to profile page" do
      post :create, user_id: user.id, language: attributes_for(:language)
      expect(response).to redirect_to user_path(user)
    end
  end


  describe "destroy #DELETE" do
    let(:language) { create(:language) }
    let!(:users_language) { create(:users_language, user: user, language: language)}

    it "deletes user's users_language" do
      expect { delete :destroy, user_id: user.id, id: language.id }.to change(UsersLanguage, :count).by -1
    end

    it "redirects to profile page" do
      delete :destroy, user_id: user.id, id: language.id
      expect(response).to redirect_to user_path(user)
    end
  end
end
