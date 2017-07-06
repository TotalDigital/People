require 'rails_helper'

RSpec.describe API::V1::Languages do

  before(:each) do
    create_doorkeeper_app
  end

  describe 'GET /languages' do
    let!(:users) { FactoryGirl.create_list(:language, 3) }

    it 'gets all languages' do
      get '/api/v1/languages', access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json.length).to eq(3)
    end
  end

  describe 'GET /languages/:language_id' do
    let!(:language) { FactoryGirl.create(:language) }

    it 'gets one language by id' do
      get "/api/v1/languages/#{language.id}", access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json).to eq(language_to_json(language))
    end
  end

  describe 'POST /languages/' do
    context 'if successful' do
      let(:language) { build(:language) }

      it 'creates the new language' do
        expect do
          post "/api/v1/languages", language: language.attributes, access_token: @dk_token.token
        end.to change(Language, :count).by 1
      end

      it 'returns a success status and new language data' do
        post "/api/v1/languages", language: language.attributes, access_token: @dk_token.token
        json = json(response.body)

        expect(response).to be_success
        expect(json.except(:id, :links)).to eq language_to_json(language).except(:id, :links)
      end
    end

    context 'if not successful' do
      let!(:language) { create(:language, name: "Some Name") }
      let(:language_no_name) { build(:language, name: '') }

      it 'returns an error status 409 if record not valid' do
        post "/api/v1/languages", language: language_no_name.attributes, access_token: @dk_token.token
        expect(response.status).to eq 409
      end

      it 'returns an error status 409 if record already exists' do
        post "/api/v1/languages", language: { name: language.name }, access_token: @dk_token.token
        expect(response.status).to eq 409
      end

    end
  end

  describe 'GET search/:term' do
    let!(:skill_a) { create(:skill, name: 'English') }
    let!(:skill_b) { create(:skill, name: 'Estonian') }

    it 'returns skills with name matching search term' do
      get '/api/v1/skills/search/eng', access_token: @dk_token.token
      json = json(response.body)
      skill_ids = json.map{ |skill| skill[:id] }

      expect(response).to be_success
      expect(skill_ids).to include skill_a.id
      expect(skill_ids).to_not include skill_b.id
    end
  end
end
