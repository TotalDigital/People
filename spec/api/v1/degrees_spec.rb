require 'rails_helper'

RSpec.describe API::V1::Degrees do
  let(:user) { create(:user) }

  before(:each) do
    create_doorkeeper_app(user: user)
  end

  describe 'GET /degrees' do
    let!(:degrees) { FactoryGirl.create_list(:degree, 3) }

    it 'gets all degrees' do
      get '/api/v1/degrees', access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json.length).to eq(3)
    end
  end

  describe 'GET /degrees/:degree_id' do
    let!(:degree) { FactoryGirl.create(:degree) }

    it 'gets one degree by id' do
      get "/api/v1/degrees/#{degree.id}", access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json.except(:links)).to eq(degree_to_json(degree).except(:links))
    end
  end

  describe 'POST /degrees/' do
    context 'with existing school' do
      let!(:school) { create(:school) }
      let(:degree) { build(:degree, user: user, school: school) }

      it 'returns a success status and the new degree' do
        post "/api/v1/degrees", degree: degree.attributes, school: { id: school.id }, access_token: @dk_token.token
        json = json(response.body)

        expect(response).to be_success
        expect(json.except(:id, :links)).to eq degree_to_json(degree).except(:id, :links)
      end

      it 'creates a new degree' do
        expect do
          post "/api/v1/degrees", degree: degree.attributes, school: { id: school.id }, access_token: @dk_token.token
        end.to change(Degree, :count).by 1
      end

      it 'does not create a new school' do
        expect do
          post "/api/v1/degrees", degree: degree.attributes, school: { id: school.id }, access_token: @dk_token.token
        end.to change(School, :count).by 0
      end
    end

    context 'with new school' do
      let(:degree) { build(:degree, user: user, school: nil) }

      it 'returns a success status and the new degree' do
        post "/api/v1/degrees", degree: degree.attributes, school: { name: "New school" }, access_token: @dk_token.token
        json          = json(response.body)
        degree.school = School.last

        expect(response).to be_success
        expect(json[:school][:id]).to eq (degree.school.id)
        expect(json.except(:id, :school, :links)).to eq degree_to_json(degree).except(:id, :school, :links)
        expect(json[:school][:name]).to eq "New school"
      end

      it 'creates a new degree' do
        expect do
          post "/api/v1/degrees", degree: degree.attributes, school: { name: "New school" }, access_token: @dk_token.token
        end.to change(Degree, :count).by 1
      end

      it 'creates a new school' do
        expect do
          post "/api/v1/degrees", degree: degree.attributes, school: { name: "New school" }, access_token: @dk_token.token
        end.to change(School, :count).by 1
      end
    end

    context 'if not successful' do
      let(:degree_no_title) { build(:degree, user: user, title: nil) }
      let(:degree_another_user) { build(:degree) }

      it 'returns an error status 409 if record not valid' do
        post "/api/v1/degrees", degree: degree_no_title.attributes, school: { name: "New school" }, access_token: @dk_token.token
        expect(response.status).to eq 409
      end

      it 'returns an error status 401 if not authorized' do
        post "/api/v1/degrees", degree: degree_another_user.attributes, school: { name: "New school" }, access_token: @dk_token.token
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PUT /degrees/:degree_id' do
    let(:degree) { create(:degree, user: user) }

    context 'if successful' do
      it 'updates degree' do
        put "/api/v1/degrees/#{degree.id}", degree: { title: "New title" }, access_token: @dk_token.token
        json = json(response.body)

        expect(response).to be_success
        expect(json[:title]).to eq "New title"
      end
    end

    context 'if not successful' do
      let!(:degree_another_user) { create(:degree) }

      it 'returns an error status 409 if record not valid' do
        put "/api/v1/degrees/#{degree.id}", degree: { title: nil }, access_token: @dk_token.token
        expect(response.status).to eq 409
      end

      it 'returns an error status 401 if not authorized' do
        put "/api/v1/degrees/#{degree_another_user.id}", degree: { title: "Some Title" }, access_token: @dk_token.token
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /degrees/:degree_id' do
    let!(:degree) { create(:degree, user_id: user.id) }

    context 'if successful' do
      it 'deletes degree' do
        expect do
          delete "/api/v1/degrees/#{degree.id}", access_token: @dk_token.token
          expect(response).to be_success
        end.to change(Degree, :count).by -1
      end
    end

    context 'if not successful' do
      let!(:degree_another_user) { create(:degree) }

      it 'returns an error status 401 if not authorized' do
        expect do
          delete "/api/v1/degrees/#{degree_another_user.id}", access_token: @dk_token.token
          expect(response.status).to eq 401
        end.to change(Degree, :count).by 0
      end
    end
  end
end
