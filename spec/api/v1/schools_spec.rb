require 'rails_helper'

RSpec.describe API::V1::Schools do

  before(:each) do
    create_doorkeeper_app
  end

  describe 'GET /schools' do
    let!(:schools) { FactoryGirl.create_list(:school, 3) }

    it 'gets all schools' do
      get '/api/v1/schools', access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json.length).to eq(3)
    end
  end

  describe 'GET /schools/:school_id' do
    let!(:school) { FactoryGirl.create(:school) }

    it 'gets one school by id' do
      get "/api/v1/schools/#{school.id}", access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json).to eq(school_to_json(school))
    end
  end

  describe 'GET search/:term' do
    let!(:school_a) { create(:school, name: 'UCLA') }
    let!(:school_b) { create(:school, name: 'HEC') }

    it 'returns schools with name matching search term' do
      get '/api/v1/schools/search/ucla', access_token: @dk_token.token
      json = json(response.body)
      school_ids = json.map{ |school| school[:id] }

      expect(response).to be_success
      expect(school_ids).to include school_a.id
      expect(school_ids).to_not include school_b.id
    end
  end
end
