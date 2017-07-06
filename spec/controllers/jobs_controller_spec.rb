require 'rails_helper'

RSpec.describe JobsController, type: :controller do

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "create #POST" do
    it "creates a new job" do
      expect { post :create, user_id: user.id, job: attributes_for(:job) }.to change(Job, :count).by 1
    end

    it "redirects to profile page" do
      post :create, user_id: user.id, job: attributes_for(:job)
      expect(response).to redirect_to user_path(user)
    end
  end

  describe "update #PATCH" do
    let!(:job) { create(:job, user: user, title: "FOO") }

    context "when successful" do
      it "updates job" do
        patch :update, format: :js, user_id: user.id, id: job.id, job: { title: "BAR" }
        job.reload
        expect(job.title).to eq "BAR"
      end

      it "renders update.js" do
        patch :update, format: :js, user_id: user.id, id: job.id, job: { title: "BAR" }
        expect(response).to render_template 'jobs/update'
      end

      it "returns success message" do
        patch :update, format: :js, user_id: user.id, id: job.id, job: { title: "BAR" }
        expect(response.flash[:notice]).to eq I18n.t'jobs.update.success'
      end
    end

    context "when not successfull" do
      it "does not update job" do
        patch :update, format: :js, user_id: user.id, id: job.id, job: { title: "" }
        job.reload
        expect(job.title).to eq "FOO"
      end

      it "renders update.js" do
        patch :update, format: :js, user_id: user.id, id: job.id, job: { title: "" }
        expect(response).to render_template 'jobs/update'
      end

      it "returns error message" do
        patch :update, format: :js, user_id: user.id, id: job.id, job: { title: "" }
        expect(response.flash[:alert]).to eq I18n.t'jobs.update.failure'
      end
    end
  end

  describe "destroy #DELETE" do
    let!(:job) { create(:job, user: user) }

    it "deletes job" do
      expect { delete :destroy, user_id: user.id, id: job.id }.to change(Job, :count).by -1
    end

    it "redirects to profile page" do
      delete :destroy, user_id: user.id, id: job.id
      expect(response).to redirect_to user_path(user)
    end
  end

  describe "import_list #POST" do
    let(:admin) { create(:user, role: 'admin') }
    let(:csv_file) { fixture_file_upload('jobs.csv', 'text/csv') }
    let(:invalid_csv_file) { fixture_file_upload('invalid.csv', 'text/csv') }

    before do
      sign_in admin
      request.env['HTTP_REFERER'] = '/admin/job/import_jobs'
    end

    context 'user without job' do
      let!(:user) { create(:user, email: "user@example.com") }

      it "creates new job" do
        expect{ post :import_list, jobs: { csv: csv_file } }.to change{ user.jobs.count }.by 1
      end
    end

    context 'user with jobs' do
      let(:user) { create(:user, email: "user@example.com") }
      let!(:job) { create(:job, user: user) }

      it "does not create new job" do
        expect{ post :import_list, jobs: { csv: csv_file } }.to change{ user.jobs.count }.by 0
      end
    end

    context 'invalid header' do
      let(:user) { create(:user, email: "user@example.com") }

      it "does not create new job" do
        expect{ post :import_list, jobs: { csv: invalid_csv_file } }.to change{ user.jobs.count }.by 0
      end
    end
  end
end
