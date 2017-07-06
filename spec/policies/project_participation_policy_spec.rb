require 'rails_helper'
require 'pundit/rspec'

RSpec.describe ProjectParticipationPolicy, type: :policy do
  subject { described_class }

  let(:user)                  { create(:user, role: "basic") }
  let(:admin)                 { create(:user, role: "admin") }
  let(:project_participation) { create(:project_participation, user: user) }

  context 'As a user' do
    let(:policy_context) { pundit_context(user) }
    let(:other_project_participation) { create(:project_participation) }

    permissions :new?, :create?, :update?, :destroy? do
      it "grants access if user is owner of project_participation" do
        expect(subject).to permit(policy_context, project_participation)
      end

      it "denies access if user not owner of project_participation" do
        expect(subject).not_to permit(policy_context, other_project_participation)
      end
    end
  end

  context 'As an admin - Edit Mode: ON ' do
    let(:policy_context) { pundit_context(admin, true) }

    permissions :new?, :create?, :update?, :destroy? do
      it "grants access" do
        expect(subject).to permit(policy_context, project_participation)
      end
    end
  end

  context 'As an admin - Edit Mode: OFF ' do
    let(:policy_context) { pundit_context(admin) }

    permissions :new?, :create?, :update?, :destroy? do
      it "denies access" do
        expect(subject).not_to permit(policy_context, project_participation)
      end
    end
  end
end
