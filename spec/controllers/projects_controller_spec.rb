require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "update #PATCH" do
    let!(:project) { create(:project, user: user, name: "FOO") }

    context "when successful" do
      it "updates project" do
        patch :update, format: :js, user_id: user.id, id: project.id, project: { name: "BAR" }
        project.reload
        expect(project.name).to eq "BAR"
      end

      it "renders update.js" do
        patch :update, format: :js, user_id: user.id, id: project.id, project: { name: "BAR" }
        expect(response).to render_template 'projects/update'
      end

      it "returns success message" do
        patch :update, format: :js, user_id: user.id, id: project.id, project: { name: "BAR" }
        expect(response.flash[:notice]).to eq I18n.t'projects.update.success'
      end
    end

    context "when not successfull" do
      it "does not update project" do
        patch :update, format: :js, user_id: user.id, id: project.id, project: { name: "" }
        project.reload
        expect(project.name).to eq "FOO"
      end

      it "renders update.js" do
        patch :update, format: :js, user_id: user.id, id: project.id, project: { name: "" }
        expect(response).to render_template 'projects/update'
      end

      it "returns error message" do
        patch :update, format: :js, user_id: user.id, id: project.id, project: { name: "" }
        expect(response.flash[:alert]).to eq I18n.t'projects.update.failure'
      end
    end
  end

  # autocomplete method
  describe "autocomplete_project_name" do
    let!(:project_1) { create(:project, name: "Project - Name") }

    it "returns a json list of projects matching terms" do
      get :autocomplete_project_name, term: "name", format: :json
      parsed_response = JSON.parse response.body
      expect(parsed_response).to eq([{"id"=>project_1.id.to_s, "label"=>"Project - Name", "value"=>"Project - Name", "location"=> project_1.location}])
    end
  end

end
