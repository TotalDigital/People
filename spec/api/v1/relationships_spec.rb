require 'rails_helper'

RSpec.describe API::V1::Relationships do
  let(:user) { create(:user) }

  before(:each) do
    create_doorkeeper_app(user: user)
  end

  describe 'GET /relationships' do
    let!(:relationships) { FactoryGirl.create_list(:relationship, 3) }
    let!(:relationship_with_users_test_role) { FactoryGirl.create(:relationship_test_users) }

    it 'gets all relationships' do
      get '/api/v1/relationships', access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json.map { |r| r[:id] }).to match_array(relationships.map(&:id) + relationships.map { |r| r.inverse.id })
    end
  end

  describe 'GET /relationships/:relationship_id' do
    let!(:relationship) { FactoryGirl.create(:relationship) }

    it 'gets one relationship by id' do
      get "/api/v1/relationships/#{relationship.id}", access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json).to eq(relationship_to_json(relationship))
    end
  end

  describe 'POST /relationships/' do
    context 'if successful' do
      let(:relationship) { build(:relationship, user_id: user.id) }

      it 'creates the new relationship and its inverse' do
        expect do
          post "/api/v1/relationships", relationship: relationship.attributes, access_token: @dk_token.token
        end.to change(Relationship, :count).by 2
      end

      it 'returns a success status and new relationship data' do
        post "/api/v1/relationships", relationship: relationship.attributes, access_token: @dk_token.token
        json = json(response.body)

        expect(response).to be_success
        expect(json.except(:id, :links)).to eq relationship_to_json(relationship).except(:id, :links)
      end
    end

    context 'if not successful' do
      let(:relationship_no_target) { build(:relationship, user_id: user.id, target_id: nil) }
      let(:relationship_another_user) { build(:relationship) }
      let(:relationship_with_user_test_role) { build(:relationship_test_users, user_id: user.id) }

      it 'returns an error status 409 if record not valid' do
        post "/api/v1/relationships", relationship: relationship_no_target.attributes, access_token: @dk_token.token
        expect(response.status).to eq 409
      end

      it 'returns an error status 401 if not authorized' do
        post "/api/v1/relationships", relationship: relationship_another_user.attributes, access_token: @dk_token.token
        expect(response.status).to eq 401
      end

      it 'returns an error status 401 if not authorized. User and target does not have the same scope' do
        post "/api/v1/relationships", relationship: relationship_with_user_test_role.attributes, access_token: @dk_token.token
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /relationships/:relationship_id' do
    let!(:relationship_owner) { create(:relationship, user_id: user.id) }
    let!(:relationship_target) { create(:relationship, target_id: user.id) }

    context 'if successful' do
      it 'deletes the relationship and the inverse relationship as the owner' do
        expect do
          delete "/api/v1/relationships/#{relationship_owner.id}", access_token: @dk_token.token
          expect(response).to be_success
        end.to change(Relationship, :count).by -2
      end

      it 'deletes the relationship and the inverse relationship as the target' do
        expect do
          delete "/api/v1/relationships/#{relationship_target.id}", access_token: @dk_token.token
          expect(response).to be_success
        end.to change(Relationship, :count).by -2
      end
    end

    context 'if not successful' do
      let!(:relationship_another_user) { create(:relationship) }

      it 'returns an error status 401 if not authorized' do
        delete "/api/v1/relationships/#{relationship_another_user.id}", access_token: @dk_token.token
        expect(response.status).to eq 401
      end
    end
  end
end
