require 'rails_helper'

RSpec.describe API::V1::Jobs do
  let(:user) { create(:user) }

  before(:each) do
    create_doorkeeper_app(user: user)
  end

  describe 'GET /jobs' do
    let!(:jobs) { FactoryGirl.create_list(:job, 3) }

    it 'gets all jobs' do
      get '/api/v1/jobs', access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json.length).to eq(3)
    end
  end

  describe 'GET /jobs/:job_id' do
    let!(:job) { FactoryGirl.create(:job) }

    it 'gets one job by id' do
      get "/api/v1/jobs/#{job.id}", access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json).to eq(job_to_json(job))
    end
  end

  describe 'POST /jobs/' do
    context 'if successful' do
      let(:job) { build(:job, user_id: user.id) }

      it 'creates the new job' do
        expect do
          post "/api/v1/jobs", job: job.attributes, access_token: @dk_token.token
        end.to change(Job, :count).by 1
      end

      it 'returns a success status and new job data' do
        post "/api/v1/jobs", job: job.attributes, access_token: @dk_token.token
        json = json(response.body)

        expect(response).to be_success
        expect(json.except(:id, :links)).to eq job_to_json(job).except(:id, :links)
      end
    end

    context 'if not successful' do
      let(:job_no_location) { build(:job, location: '') }
      let(:job_another_user) { build(:job) }

      it 'returns an error status 409 if record not valid' do
        post "/api/v1/jobs", job: job_no_location.attributes, access_token: @dk_token.token
        expect(response.status).to eq 409
      end

      it 'returns an error status 401 if not authorized' do
        post "/api/v1/jobs", job: job_another_user.attributes, access_token: @dk_token.token
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PUT /jobs/:job_id' do
    let(:job) { create(:job, user: user, title: "Old Job Title", start_date: "2016-01-01", end_date: "2016-06-01", description: "Old Description", location: "Old location") }

    context 'if successful' do
      it 'updates a job' do
        put "/api/v1/jobs/#{job.id}",
            job:          {
                title:       "New Job Title",
                start_date:  "2017-01-01",
                end_date:    "2017-06-01",
                description: "New Description",
                location:    "New location"
            },
            access_token: @dk_token.token
        json = json(response.body)

        expect(response).to be_success
        expect(json[:title]).to eq "New Job Title"
        expect(json[:start_date]).to eq "2017-01-01"
        expect(json[:end_date]).to eq "2017-06-01"
        expect(json[:description]).to eq "New Description"
        expect(json[:location]).to eq "New location"
      end
    end

    context 'if not successful' do
      let(:job_another_user) { create(:job) }

      it 'returns an error status 409 if record not valid' do
        put "/api/v1/jobs/#{job.id}", job: { location: '' }, access_token: @dk_token.token
        expect(response.status).to eq 409
      end

      it 'returns an error status 401 if not authorized' do
        put "/api/v1/jobs/#{job_another_user.id}", job: { location: 'Some Location' }, access_token: @dk_token.token
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /jobs/:job_id' do
    let!(:job) { create(:job, user_id: user.id) }

    it 'returns a success status' do
      delete "/api/v1/jobs/#{job.id}", access_token: @dk_token.token
      expect(response).to be_success
    end

    it 'deletes the job and the inverse job' do
      expect do
        delete "/api/v1/jobs/#{job.id}", access_token: @dk_token.token
      end.to change(Job, :count).by -1
    end
  end

end
