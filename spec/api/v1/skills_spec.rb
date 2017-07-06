require 'rails_helper'

RSpec.describe API::V1::Skills do

  before(:each) do
    create_doorkeeper_app
  end

  describe 'GET /skills' do
    let!(:skills) { FactoryGirl.create_list(:skill, 3) }

    it 'gets all skills' do
      get '/api/v1/skills', access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json.length).to eq(3)
    end
  end

  describe 'GET /skills/:skill_id' do
    let!(:skill) { FactoryGirl.create(:skill) }

    it 'gets one skill by id' do
      get "/api/v1/skills/#{skill.id}", access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json).to eq(skill_to_json(skill))
    end
  end

  describe 'POST /skills/' do
    context 'if successful' do
      let(:skill) { build(:skill) }

      it 'creates the new skill' do
        expect do
          post "/api/v1/skills", skill: skill.attributes, access_token: @dk_token.token
        end.to change(Skill, :count).by 1
      end

      it 'returns a success status and new skill data' do
        post "/api/v1/skills", skill: skill.attributes, access_token: @dk_token.token
        json = json(response.body)

        expect(response).to be_success
        expect(json.except(:id, :links)).to eq skill_to_json(skill).except(:id, :links)
      end
    end

    context 'if not successful' do
      let!(:skill) { create(:skill, name: "Some Name") }
      let(:skill_no_name) { build(:skill, name: '') }

      it 'returns an error status 409 if record not valid' do
        post "/api/v1/skills", skill: skill_no_name.attributes, access_token: @dk_token.token
        expect(response.status).to eq 409
      end

      it 'returns an error status 409 if record already exists' do
        post "/api/v1/skills", skill: { name: skill.name }, access_token: @dk_token.token
        expect(response.status).to eq 409
      end

    end
  end


  describe 'GET search/:term' do
    let!(:skill_a) { create(:skill, name: 'Web Dev') }
    let!(:skill_b) { create(:skill, name: 'Design') }

    it 'returns skills with name matching search term' do
      get '/api/v1/skills/search/web', access_token: @dk_token.token
      json      = json(response.body)
      skill_ids = json.map { |skill| skill[:id] }

      expect(response).to be_success
      expect(skill_ids).to include skill_a.id
      expect(skill_ids).to_not include skill_b.id
    end
  end
end
