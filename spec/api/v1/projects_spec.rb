require 'rails_helper'

RSpec.describe API::V1::Projects do
  let(:user) { create(:user) }

  before(:each) do
    create_doorkeeper_app(user: user)
  end

  describe 'GET /projects' do
    let!(:projects) { FactoryGirl.create_list(:project, 3) }

    it 'gets all projects' do
      get '/api/v1/projects', access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json.length).to eq(3)
    end
  end

  describe 'GET /projects/:project_id' do
    let!(:project) { FactoryGirl.create(:project) }

    let(:user_test_role) { FactoryGirl.create(:user_test_role) }
    let!(:project_user_test_role) { FactoryGirl.create(:project, user: user_test_role) }

    it 'gets one project by id' do
      get "/api/v1/projects/#{project.id}", access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json).to eq(project_to_json(project))
    end

    it 'does not get a project created by user test role' do
      get "/api/v1/projects/#{project_user_test_role.id}", access_token: @dk_token.token
      expect(response.status).to eq 404
    end
  end

  describe 'PUT /projects/:project_id' do
    let(:project) { create(:project, user: user) }

    context 'if successful' do
      it 'updates a project' do
        put "/api/v1/projects/#{project.id}", project: { name: "New name" }, access_token: @dk_token.token
        json = json(response.body)

        expect(response).to be_success
        expect(json[:name]).to eq "New name"
      end
    end

    context 'if not successful' do
      let!(:project_another_user) { create(:project) }

      it 'returns an error status 409 if record not valid' do
        put "/api/v1/projects/#{project.id}", project: { name: "" }, access_token: @dk_token.token
        expect(response.status).to eq 409
      end

      it 'returns an error status 401 if not authorized' do
        put "/api/v1/projects/#{project_another_user.id}", project: { name: "Some Name" }, access_token: @dk_token.token
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /projects/:project_id' do
    let!(:project) { create(:project, user_id: user.id) }

    context 'if successful' do
      it 'deletes project' do
        expect do
          delete "/api/v1/projects/#{project.id}", access_token: @dk_token.token
          expect(response).to be_success
        end.to change(Project, :count).by -1
      end
    end

    context 'if not successful' do
      let!(:project_another_user) { create(:project) }

      it 'returns an error status 401 if not authorized' do
        expect do
          delete "/api/v1/projects/#{project_another_user.id}", access_token: @dk_token.token
          expect(response.status).to eq 401
        end.to change(Project, :count).by 0
      end
    end
  end

  describe 'GET search/:term' do
    let!(:project_a) { create(:project, name: 'Web Tool') }
    let!(:project_b) { create(:project, name: 'Design Tool') }

    let(:user_test_role) { FactoryGirl.create(:user_test_role) }
    let!(:project_user_test_role) { FactoryGirl.create(:project, user: user_test_role, name: 'Finance Tool') }

    it 'returns projects with name matching search term' do
      get '/api/v1/projects/search/web', access_token: @dk_token.token
      json        = json(response.body)
      project_ids = json.map { |project| project[:id] }

      expect(response).to be_success
      expect(project_ids).to include project_a.id
      expect(project_ids).to_not include project_b.id
    end

    it "returns projects from people's users only" do
      get '/api/v1/projects/search/tool', access_token: @dk_token.token
      json        = json(response.body)
      project_ids = json.map { |project| project[:id] }

      expect(response).to be_success
      expect(project_ids).to match_array([project_a.id, project_b.id])
    end
  end
end
