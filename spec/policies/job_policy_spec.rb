require 'rails_helper'
require 'pundit/rspec'

RSpec.describe JobPolicy, type: :policy do
  subject { described_class }

  let(:user)    { create(:user, role: "basic") }
  let(:admin)   { create(:user, role: "admin") }
  let(:job)  { create(:job, user: user) }

  context 'As a user' do
    let(:policy_context) { pundit_context(user) }
    let(:other_job)   { create(:job) }

    permissions :new?, :create?, :update?, :destroy? do
      it "grants access if user is owner of job" do
        expect(subject).to permit(policy_context, job)
      end

      it "denies access if user not owner of job" do
        expect(subject).not_to permit(policy_context, other_job)
      end
    end
  end

  context 'As an admin - Edit Mode: ON ' do
    let(:policy_context) { pundit_context(admin, true) }

    permissions :new?, :create?, :update?, :destroy? do
      it "grants access" do
        expect(subject).to permit(policy_context, job)
      end
    end
  end

  context 'As an admin - Edit Mode: OFF ' do
    let(:policy_context) { pundit_context(admin) }

    permissions :new?, :create?, :update?, :destroy? do
      it "denies access" do
        expect(subject).not_to permit(policy_context, job)
      end
    end
  end
end
