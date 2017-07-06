require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:user) { create(:user) }

  describe 'autocomplete #GET' do
    let!(:sam) { create(:user, first_name: 'Sam123', last_name: "Jones", job_title: "CEO") }
    let!(:tom) { create(:user, first_name: 'Tom123', last_name: "Jones", job_title: "CTO") }

    before { sign_in(user) }

    it 'renders users with last name matching term search' do
      get :autocomplete, term: "sam123", format: :json
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq [{ "id" => sam.id, "label" => "Sam123 Jones - CEO" }]
    end

    it 'renders users with first name matching term search' do
      get :autocomplete, term: "jone", format: :json
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to match_array [{ "id" => sam.id, "label" => "Sam123 Jones - CEO" }, { "id" => tom.id, "label" => "Tom123 Jones - CTO" }]
    end

    it 'does not fecth users with role test with a people signed in user' do
      get :autocomplete, term: "test", format: :json
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to match_array []
    end
  end

  describe 'show #GET' do

    context 'when successful' do
      before { sign_in(user) }

      it 'renders show template using user id' do
        get :show, id: user.id
        expect(subject).to render_template :show
        expect(assigns[:user]).to eq(user)
      end

      it 'renders show template using user slug' do
        get :show, id: user.slug
        expect(subject).to render_template :show
        expect(assigns[:user]).to eq(user)
      end

      it 'returns a UserDecorator object' do
        get :show, id: user.id
        expect(assigns(:user).class).to eq UserDecorator
      end
    end

    context 'when the signed in user has no job_title' do
      let!(:user_no_job_title) { create(:user, job_title: nil, internal_id: nil) }
      before { sign_in(user_no_job_title) }

      it 'redirects to index onboarding if user is trying to get another path' do
        get :show, id: user_no_job_title.id
        expect(response).to redirect_to(onboarding_path)
      end
    end

    context 'when the user you try to fetch has a test role' do
      let!(:user_test_role) { create(:user_test_role, first_name: 'Test', last_name: 'Test', job_title: 'TEST') }
      before { sign_in(user) }

      it 'does not fetch user with role test with a people signed in user' do
        expect do
          get :show, id: user_test_role.slug
        end.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'update #PATCH' do
    before { sign_in(user) }

    context 'with html format' do
      context 'with valid params' do
        it 'updates user' do
          patch :update, id: user.id, user: { first_name: 'Igor' }
          user.reload
          expect(user.first_name).to eq 'Igor'
        end

        it 'redirects to user profile with flash notice' do
          patch :update, id: user.id, user: { first_name: 'Igor' }
          expect(response).to redirect_to user_path(user)
          expect(flash[:notice]).to eq I18n.t'profiles.update.success'
        end
      end

      context 'with unvalid params' do
        it 'does not update user' do
          patch :update, id: user.id, user: { first_name: '' }
          user.reload
          expect(user.first_name).to_not eq ''
        end

        it 'redirects to user profile with flash notice' do
          patch :update, id: user.id, user: { first_name: '' }
          expect(response).to redirect_to user_path(user)
          expect(flash[:alert]).to eq I18n.t'profiles.update.failure'
        end

        it 'redirects to user profile with flash notice if onboarding params' do
          patch :update, id: user.id, user: { first_name: '' }, onboarding: true
          expect(response).to render_template 'onboarding/index'
          expect(flash[:alert]).to eq I18n.t'profiles.update.failure'
        end
      end
    end

    context "with js format" do
      let!(:user) { create(:user, first_name: "FOO") }

      context "when successful" do
        it "updates user" do
          patch :update, format: :js, user_id: user.id, id: user.id, user: { first_name: "BAR" }
          user.reload
          expect(user.first_name).to eq "BAR"
        end

        it "renders update.js" do
          patch :update, format: :js, user_id: user.id, id: user.id, user: { first_name: "BAR" }
          expect(response).to render_template 'profiles/update'
        end

        it "returns success message" do
          patch :update, format: :js, user_id: user.id, id: user.id, user: { first_name: "BAR" }
          expect(response.flash[:notice]).to eq I18n.t'profiles.update.success'
        end
      end

      context "when not successfull" do
        it "does not update user" do
          patch :update, format: :js, user_id: user.id, id: user.id, user: { first_name: "" }
          user.reload
          expect(user.first_name).to eq "FOO"
        end

        it "renders update.js" do
          patch :update, format: :js, user_id: user.id, id: user.id, user: { first_name: "" }
          expect(response).to render_template 'profiles/update'
        end

        it "returns error message" do
          patch :update, format: :js, user_id: user.id, id: user.id, user: { first_name: "" }
          expect(response.flash[:alert]).to eq I18n.t'profiles.update.failure'
        end
      end
    end
  end

  describe 'index #GET' do
    let!(:michel) { create(:user, first_name: "michel") }
    let!(:robert) { create(:user, first_name: "robert", job_title: "CEO") }
    let!(:michel_test) { create(:user_test_role, first_name: "michel", job_title: "CEO") }

    before { sign_in(user) }

    it 'redirects to root' do
      get :index
      expect(response).to render_template "index"
    end

    context "if ransack query" do
      it 'returns users matching query term' do
        get :index, q: { first_name_or_job_title_or_entity_cont: "Mich" }
        expect(assigns[:users]).to include michel
        expect(assigns[:users]).to_not include robert
        expect(assigns[:users]).to_not include michel_test
      end

      it 'returns users matching query term' do
        get :index, q: { first_name_or_job_title_or_entity_cont: "ceo" }
        expect(assigns[:users]).to_not include michel
        expect(assigns[:users]).to include robert
        expect(assigns[:users]).to_not include michel_test
      end
    end

    context "if full-text search" do
      it 'returns users matching query term' do
        get :index, search: { term: "Mich" }
        expect(assigns[:users]).to include michel
        expect(assigns[:users]).to_not include robert
        expect(assigns[:users]).to_not include michel_test
      end

      it 'returns users matching query term' do
        get :index, search: { term: "ceo" }
        expect(assigns[:users]).to_not include michel
        expect(assigns[:users]).to include robert
        expect(assigns[:users]).to_not include michel_test
      end
    end
  end

  describe 'destroy #DELETE' do
    let!(:user) { create(:user, password: "changeme") }
    before do
      request.env['HTTP_REFERER'] = edit_user_registration_path
      sign_in(user)
    end

    context 'if successful' do
      it 'deletes user' do
        expect{ delete :destroy, id: user.id, user: { password: "changeme"} }.to change{ User.count }.by -1
      end

      it 'redirects to root with flash message' do
        delete :destroy, id: user.id, user: { password: "changeme"}
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to eq I18n.t'profiles.destroy.success'
      end
    end

    context 'if not successful' do
      it 'does not delete user' do
        expect{ delete :destroy, id: user.id, user: { password: ""} }.to change{ User.count }.by 0
      end

      it 'redirects to root with flash message' do
        delete :destroy, id: user.id, user: { password: ""}
        expect(response).to redirect_to edit_user_registration_path
        expect(flash[:alert]).to eq I18n.t'profiles.destroy.failure'
      end
    end
  end

  describe "import_list #POST" do
    let(:admin) { create(:user, role: 'admin') }
    let(:csv_file) { fixture_file_upload('users.csv', 'text/csv') }
    let(:invalid_csv_file) { fixture_file_upload('invalid.csv', 'text/csv') }

    before do
      sign_in admin
      request.env['HTTP_REFERER'] = '/admin/user/import_jobs'
    end

    context 'valid file' do
      it 'creates new user' do
        expect{ post :import_list, users: { csv: csv_file } }.to change{ User.count }.by 1
      end

      it 'creates a new user with following attributes : email, last_name, first_name, job_title, entity, internal_id, phone' do
        post :import_list, users: { csv: csv_file }
        imported_user = User.find_by(email: "imported.user@example.com")
        attribute_values = imported_user.attributes.values_at("email", "last_name", "first_name", "job_title", "entity", "internal_id", "phone")
        expect(attribute_values).to_not include nil
      end

      it 'creates a new user with skills' do
        post :import_list, users: { csv: csv_file }
        imported_user = User.find_by(email: "imported.user@example.com")
        expect(imported_user.skills.any?).to be_truthy
      end
    end

    context 'invalid header' do
      it "does not create new user" do
        expect{ post :import_list, users: { csv: invalid_csv_file } }.to change{ User.count }.by 0
      end
    end
  end
end
