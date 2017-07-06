require 'rails_helper'
require 'pundit/rspec'

RSpec.describe ProjectPolicy, type: :policy do
  subject { described_class }

  let(:user)    { create(:user, role: "basic") }
  let(:admin)   { create(:user, role: "admin") }
  let(:project) { create(:project, user: user) }

  context 'As a user' do
    let(:policy_context) { pundit_context(user) }
    let(:other_project) { create(:project) }

    permissions :edit?, :update?, :destroy? do
      it "grants access if user is owner of project" do
        expect(subject).to permit(policy_context, project)
      end

      it "denies access if user not owner of project" do
        expect(subject).not_to permit(policy_context, other_project)
      end
    end

    permissions :index?, :new?, :create? do
      it "grants access to any user" do
        expect(subject).to permit(policy_context)
      end
    end
  end

  context 'As an admin - Edit Mode: ON ' do
    let(:policy_context) { pundit_context(admin, true) }

    permissions :edit?, :update?, :destroy? do
      it "grants access" do
        expect(subject).to permit(policy_context, project)
      end
    end
  end

  context 'As an admin - Edit Mode: OFF ' do
    let(:policy_context) { pundit_context(admin) }

    permissions :edit?, :update?, :destroy? do
      it "denies access" do
        expect(subject).not_to permit(policy_context, project)
      end
    end
  end
end
