# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string
#  location   :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  let!(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }

  describe "transfer_ownership_or_destroy" do

    let!(:participation) { create(:project_participation, project: project, user: user) }

    context "if no other participant to project" do
      it "destroys project" do
        expect { project.transfer_ownership_or_destroy }.to change(Project, :count).by -1
      end
    end

    context "if many participants" do
      let!(:other_participation) { create(:project_participation, project: project) }
      it "gives ownership to following owner" do
        project.transfer_ownership_or_destroy
        project.reload
        expect(project.user).to eq other_participation.user
      end
    end
  end

  describe "next_owner" do
    let!(:participation_1) { create(:project_participation, project: project, user: user) }
    let!(:participation_2) { create(:project_participation, project: project) }
    let!(:participation_3) { create(:project_participation, project: project) }

    it "returns oldest participant after current owner" do
      expect(project.send(:next_owner)).to eq participation_2.user
    end
  end

  describe 'dependencies on destroy' do

    context 'if project has project_participations' do
      let!(:project)                { create(:project) }
      let!(:project_participation)  { create(:project_participation, project: project) }

      it 'cannot delete project' do
        expect { project.destroy }.to change(Project, :count).by(0)
      end
    end

    context 'if project has no project_participations' do
      let!(:project) { create(:project) }

      it 'deletes the project' do
        expect { project.destroy }.to change(Project, :count).by(-1)
      end
    end
  end
end
