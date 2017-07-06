require 'rails_helper'

RSpec.describe ProjectParticipationsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:project) { create(:project) }

  before do
    sign_in user
  end

  describe 'create #POST' do

    context 'when project already exists' do
      let(:project_test) { create(:project, user: create(:user_test_role)) }
      let(:project_participation_attributes) { attributes_for(:project_participation, user_id: user.id, project_id: project.id) }
      let(:project_participation_test_attributes) { attributes_for(:project_participation, user_id: user.id, project_id: project_test.id) }

      it 'creates a new ProjectParticipation' do
        expect do
          post :create, user_id: user.id, project_participation: project_participation_attributes
        end.to change(ProjectParticipation, :count).by 1
      end

      it 'does not create a new project' do
        expect do
          post :create, user_id: user.id, project_participation: project_participation_attributes
        end.to change(Project, :count).by 0
      end

      it 'redirects to profile page with flash notice' do
        post :create, user_id: user.id, project_participation: project_participation_attributes
        expect(response).to redirect_to user_path(user)
        expect(flash[:notice]).to eq "Added participation to project #{project.name}"
      end

      it 'does not create a new ProjectParticipation because of different users scopes' do
        expect do
          post :create, user_id: user.id, project_participation: project_participation_test_attributes
        end.to change(ProjectParticipation, :count).by 0
      end
    end

    context 'when project does not exist yet' do
      let(:project_participation_attributes) { { project_id: "", project_name: "another new project", project_location: "Brussels", start_date: "2017-01-01", end_date: "2017-02-01", role_description: "plop" } }

      it 'creates a new Project' do
        expect do
          post :create, user_id: user.id, project_participation: project_participation_attributes
        end.to change(Project, :count).by 1
      end

      it 'creates a new ProjectParticipation' do
        expect do
          post :create, user_id: user.id, project_participation: project_participation_attributes
        end.to change(ProjectParticipation, :count).by 1
      end
    end
  end

  describe "update #PATCH" do
    let!(:project_participation) { create(:project_participation, user: user, role_description: "FOO") }

    context "when successful" do
      it "updates project_participation" do
        patch :update, format: :js, user_id: user.id, id: project_participation.id, project_participation: { role_description: "BAR" }
        project_participation.reload
        expect(project_participation.role_description).to eq "BAR"
      end

      it "renders update.js" do
        patch :update, format: :js, user_id: user.id, id: project_participation.id, project_participation: { role_description: "BAR" }
        expect(response).to render_template 'projects/update'
      end

      it "returns success message" do
        patch :update, format: :js, user_id: user.id, id: project_participation.id, project_participation: { role_description: "BAR" }
        expect(response.flash[:notice]).to eq I18n.t'project_participations.update.success'
      end
    end

    context "when not successfull" do
      it "does not update project_participation" do
        patch :update, format: :js, user_id: user.id, id: project_participation.id, project_participation: { start_date: nil }
        project_participation.reload
        expect(project_participation.start_date).to_not eq nil
      end

      it "renders update.js" do
        patch :update, format: :js, user_id: user.id, id: project_participation.id, project_participation: { start_date: nil }
        expect(response).to render_template 'projects/update'
      end

      it "returns error message" do
        patch :update, format: :js, user_id: user.id, id: project_participation.id, project_participation: { start_date: nil }
        expect(response.flash[:alert]).to eq I18n.t'project_participations.update.failure'
      end
    end
  end

  describe 'destroy #DELETE' do

    context 'when only participants and owner of the project' do
      let(:project) { create(:project, user_id: user.id) }
      let!(:project_participation) { create(:project_participation, user_id: user.id, project_id: project.id) }

      before do
        user.reload
      end

      it 'deletes project_participation' do
        expect do
          delete :destroy, user_id: user.id, id: project_participation.id
        end.to change(ProjectParticipation, :count).by -1
      end

      it 'deletes project related to project_participation' do
        expect do
          delete :destroy, user_id: user.id, id: project_participation.id
        end.to change(Project, :count).by -1
      end

      it 'redirects to profile page' do
        delete :destroy, user_id: user.id, id: project_participation.id
        expect(response).to redirect_to user_path(user)
      end
    end

    context 'when several participants to the project' do
      let(:project) { create(:project, user_id: user.id) }
      let!(:project_participation) { create(:project_participation, user_id: user.id, project_id: project.id) }
      let!(:second_project_participation) { create(:project_participation, project_id: project.id) }
      let!(:third_project_participation) { create(:project_participation, project_id: project.id) }

      before do
        user.reload
      end

      it 'deletes project_participation' do
        expect do
          delete :destroy, user_id: user.id, id: project_participation.id
        end.to change(ProjectParticipation, :count).by -1
      end

      it 'does not delete project related to project_participation' do
        expect do
          delete :destroy, user_id: user.id, id: project_participation.id
        end.to change(Project, :count).by 0
      end

      it 'transfers project ownership to 2nd participant' do
        delete :destroy, user_id: user.id, id: project_participation.id
        project.reload
        expect(project.user).to eq second_project_participation.user
      end

      it 'redirects to profile page' do
        delete :destroy, user_id: user.id, id: project_participation.id
        expect(response).to redirect_to user_path(user)
      end
    end
  end
end
