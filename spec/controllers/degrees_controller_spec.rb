require 'rails_helper'

RSpec.describe DegreesController, type: :controller do

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "create #POST" do
    context "if school does not exist yet" do
      let(:degree_attributes) { attributes_for(:degree, school_id: "").merge(school_name: "HEC") }

      it "creates a new degree" do
        expect { post :create, user_id: user.id, degree: degree_attributes }.to change(Degree, :count).by 1
      end

      it "creates a new school" do
        expect { post :create, user_id: user.id, degree: degree_attributes }.to change(School, :count).by 1
      end

      it "redirects to profile page" do
        post :create, user_id: user.id, degree: degree_attributes
        expect(response).to redirect_to user_path(user)
      end

    end

    context "if school exists already" do
      let!(:school) { create(:school) }
      let(:degree_attributes) { attributes_for(:degree, school_id: school.id).merge(school_name: school.name) }

      it "creates a new degree" do
        expect { post :create, user_id: user.id, degree: degree_attributes }.to change(Degree, :count).by 1
      end

      it "does not create a new school" do
        expect { post :create, user_id: user.id, degree: degree_attributes }.to change(School, :count).by 0
      end

      it "redirects to profile page" do
        post :create, user_id: user.id, degree: degree_attributes
        expect(response).to redirect_to user_path(user)
      end
    end
  end

  describe "update #PATCH" do
    let!(:degree) { create(:degree, user: user, title: "FOO") }

    context "when successful" do
      it "updates degree" do
        patch :update, format: :js, user_id: user.id, id: degree.id, degree: { title: "BAR" }
        degree.reload
        expect(degree.title).to eq "BAR"
      end

      it "renders update.js" do
        patch :update, format: :js, user_id: user.id, id: degree.id, degree: { title: "BAR" }
        expect(response).to render_template 'degrees/update'
      end

      it "returns success message" do
        patch :update, format: :js, user_id: user.id, id: degree.id, degree: { title: "BAR" }
        expect(response.flash[:notice]).to eq I18n.t'degrees.update.success'
      end
    end

    context "when not successfull" do
      it "does not update degree" do
        patch :update, format: :js, user_id: user.id, id: degree.id, degree: { title: "" }
        degree.reload
        expect(degree.title).to eq "FOO"
      end

      it "renders update.js" do
        patch :update, format: :js, user_id: user.id, id: degree.id, degree: { title: "" }
        expect(response).to render_template 'degrees/update'
      end

      it "returns error message" do
        patch :update, format: :js, user_id: user.id, id: degree.id, degree: { title: "" }
        expect(response.flash[:alert]).to eq I18n.t'degrees.update.failure'
      end
    end
  end

  describe "destroy #DELETE" do
    let!(:degree) { create(:degree, user: user) }

    it "deletes user's users_degree" do
      expect { delete :destroy, user_id: user.id, id: degree.id }.to change(Degree, :count).by -1
    end

    it "redirects to profile page" do
      delete :destroy, user_id: user.id, id: degree.id
      expect(response).to redirect_to user_path(user)
    end
  end
end
