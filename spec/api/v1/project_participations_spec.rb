require 'rails_helper'

RSpec.describe API::V1::ProjectParticipations do
  let(:user) { create(:user) }

  before(:each) do
    create_doorkeeper_app(user: user)
  end

  describe 'GET /project_participations' do
    let!(:project_participations) { FactoryGirl.create_list(:project_participation, 3) }

    let(:user_test_role) { FactoryGirl.create(:user_test_role) }
    let!(:project_participation_user_test_role) { FactoryGirl.create(:project_participation, user: user_test_role) }

    it 'gets all project_participations' do
      get '/api/v1/project_participations', access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json.length).to eq(3)
    end
  end

  describe 'GET /project_participations/:project_participation_id' do
    let!(:project_participation) { FactoryGirl.create(:project_participation) }

    let(:user_test_role) { FactoryGirl.create(:user_test_role) }
    let!(:project_participation_user_test_role) { FactoryGirl.create(:project_participation, user: user_test_role) }

    it 'gets one project_participation by id' do
      get "/api/v1/project_participations/#{project_participation.id}", access_token: @dk_token.token
      json = json(response.body)

      expect(response).to be_success
      expect(json).to eq(project_participation_to_json(project_participation))
    end

    it 'does not get the project_participation created by a test user' do
      get "/api/v1/project_participations/#{project_participation_user_test_role.id}", access_token: @dk_token.token
      expect(response.status).to eq 404
    end
  end

  describe 'POST /project_participations/' do
    context 'with existing project' do
      let!(:project) { create(:project, user: user) }
      let(:project_participation) { build(:project_participation, user: user, project: project) }
      let(:project_participation_user_test_role) { build(:project_participation, user: create(:user_test_role), project: project) }

      it 'returns a success status and the new project_participation' do
        post "/api/v1/project_participations",
             project_participation: project_participation.attributes,
             project:               { id: project.id },
             access_token:          @dk_token.token

        json = json(response.body)

        expect(response).to be_success
        expect(json.except(:id, :links)).to eq project_participation_to_json(project_participation).except(:id, :links)
      end

      it 'creates a new project_participation' do
        expect do
          post "/api/v1/project_participations",
               project_participation: project_participation.attributes,
               project:               { id: project.id },
               access_token:          @dk_token.token
        end.to change(ProjectParticipation, :count).by 1
      end

      it 'does not create a new project' do
        expect do
          post "/api/v1/project_participations",
               project_participation: project_participation.attributes,
               project:               { id: project.id },
               access_token:          @dk_token.token
        end.to change(Project, :count).by 0
      end

      it 'does not create a new project_particiption because of different users scopes' do
        post "/api/v1/project_participations",
             project_participation: project_participation_user_test_role.attributes,
             project:               { id: project.id },
             access_token:          @dk_token.token

        expect(response.status).to eq 401
      end
    end

    context 'with new project' do
      let(:project_participation) { build(:project_participation, user: user, project: nil) }

      it 'returns a success status and the new project_participation' do
        post "/api/v1/project_participations",
             project_participation: project_participation.attributes,
             project:               { name: "New project", location: "Paris" },
             access_token:          @dk_token.token

        json                          = json(response.body)
        project_participation.project = Project.last

        expect(response).to be_success
        expect(json[:project][:id]).to eq (project_participation.project.id)
        expect(json.except(:id, :links)).to eq project_participation_to_json(project_participation).except(:id, :links)
      end

      it 'creates a new project_participation' do
        expect do
          post "/api/v1/project_participations",
               project_participation: project_participation.attributes,
               project:               { name: "New project", location: "Paris" },
               access_token:          @dk_token.token
        end.to change(ProjectParticipation, :count).by 1
      end

      it 'creates a new project' do
        expect do
          post "/api/v1/project_participations",
               project_participation: project_participation.attributes,
               project:               { name: "New project", location: "Paris" },
               access_token:          @dk_token.token
        end.to change(Project, :count).by 1
      end
    end

    context 'if not successful' do
      let!(:project) { create(:project) }
      let(:project_participation_no_start_date) { build(:project_participation, user: user, start_date: nil) }

      it 'returns an error status 409 if record not valid' do
        post "/api/v1/project_participations",
             project_participation: project_participation_no_start_date.attributes,
             project:               { id: project.id },
             access_token:          @dk_token.token

        expect(response.status).to eq 409
      end
    end
  end

  describe 'PUT /project_participations/:project_participation_id' do
    let(:project_participation) { create(:project_participation, user: user) }

    context 'if successful' do
      it 'updates project_participation' do
        put "/api/v1/project_participations/#{project_participation.id}",
            project_participation: { role_description: "New role description" },
            access_token:          @dk_token.token

        json = json(response.body)

        expect(response).to be_success
        expect(json[:role_description]).to eq "New role description"
      end
    end

    context 'if not successful' do
      let!(:project_participation_another_user) { create(:project_participation) }

      it 'returns an error status 409 if record not valid' do
        put "/api/v1/project_participations/#{project_participation.id}",
            project_participation: { start_date: "" },
            access_token:          @dk_token.token

        expect(response.status).to eq 409
      end

      it 'returns an error status 401 if not authorized' do
        put "/api/v1/project_participations/#{project_participation_another_user.id}",
            project_participation: { location: "Some Location" },
            access_token:          @dk_token.token

        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE /project_participations/:project_participation_id' do
    let!(:project_participation) { create(:project_participation, user_id: user.id) }

    context 'if successful' do
      it 'deletes project_participation' do
        expect do
          delete "/api/v1/project_participations/#{project_participation.id}", access_token: @dk_token.token
          expect(response).to be_success
        end.to change(ProjectParticipation, :count).by -1
      end
    end

    context 'if not successful' do
      let!(:project_participation_another_user) { create(:project_participation) }

      it 'returns an error status 401 if not authorized' do
        expect do
          delete "/api/v1/project_participations/#{project_participation_another_user.id}", access_token: @dk_token.token
          expect(response.status).to eq 401
        end.to change(ProjectParticipation, :count).by 0
      end
    end
  end
end
