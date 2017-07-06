require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do

  let!(:user)      { create(:user) }
  let!(:colleague) { create(:user, first_name: 'Michel', last_name: 'DELACOMPTA') }

  before do
    sign_in user
    request.env['HTTP_REFERER'] = users_path
  end

  describe 'new #GET' do
    it 'renders new template' do
      xhr :get, :new, relationship: { user_id: user.id, target_id: colleague.id}, format: :js
      expect(response).to render_template :new
    end

    it 'sets new relationship without kind' do
      xhr :get, :new, relationship: { user_id: user.id, target_id: colleague.id}, format: :js
      expect(assigns[:relationship].target).to eq colleague
      expect(assigns[:relationship].user).to eq user
      expect(assigns[:relationship].kind).to eq nil
    end
  end

  describe 'create #POST' do
    context 'when success' do
      it 'creates a 2 new relationships' do
        expect do
          post :create, format: :js, relationship: { kind: 'is_managed_by', user_id: user.id, target_id: colleague.id }
        end.to change(Relationship, :count).by 2
      end

      it 'redirects to user profile with flash notice' do
        post :create, format: :js, relationship: { kind: 'is_managed_by', user_id: user.id, target_id: colleague.id }
        expect(response).to render_template('update')
        expect(flash[:notice]).to eq 'Added relationship with Michel DELACOMPTA'
      end
    end

    context 'when failures' do
      it 'redirects to user profile with flash error if missing attributes' do
        post :create, format: :js, relationship: { user_id: user.id, target_id: colleague.id }
        expect(response).to render_template('update')
        expect(flash[:alert]).to eq 'Unable to add this relationship'
      end
    end
  end

  describe 'destroy #DELETE' do
    let!(:relationship) { create(:relationship, user_id: user.id, target_id: colleague.id) }

    it 'deletes the relationship and the reverse relationship' do
      expect{ delete :destroy, id: relationship.id, format: :js }.to change(Relationship, :count).by -2
    end

    it 'renders update.js' do
      delete :destroy, id: relationship.id, format: :js
      expect(response).to render_template 'update'
      expect(flash[:notice]).to eq 'Removed relationship with Michel DELACOMPTA'
    end
  end
end
