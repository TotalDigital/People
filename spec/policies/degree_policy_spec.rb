require 'rails_helper'
require 'pundit/rspec'

RSpec.describe DegreePolicy, type: :policy do
  subject { described_class }

  let(:user)    { create(:user, role: "basic") }
  let(:admin)   { create(:user, role: "admin") }
  let(:degree)  { create(:degree, user: user) }

  context 'As a user' do
    let(:policy_context) { pundit_context(user) }
    let(:other_degree)   { create(:degree) }

    permissions :create?, :update?, :destroy? do
      it "grants access if user is owner of degree" do
        expect(subject).to permit(policy_context, degree)
      end

      it "denies access if user not owner of degree" do
        expect(subject).not_to permit(policy_context, other_degree)
      end
    end
  end

  context 'As an admin - Edit Mode: ON ' do
    let(:policy_context) { pundit_context(admin, true) }

    permissions :create?, :update?, :destroy? do
      it "grants access" do
        expect(subject).to permit(policy_context, degree)
      end
    end
  end

  context 'As an admin - Edit Mode: OFF ' do
    let(:policy_context) { pundit_context(admin) }

    permissions :create?, :update?, :destroy? do
      it "denies access" do
        expect(subject).not_to permit(policy_context, degree)
      end
    end
  end
end
