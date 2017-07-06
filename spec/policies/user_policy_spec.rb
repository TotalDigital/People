require 'rails_helper'
require 'pundit/rspec'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class }

  let(:user)        { create(:user, role: "basic") }
  let(:other_user)  { create(:user) }
  let(:admin)       { create(:user, role: "admin") }

  context 'As a user' do
    let(:policy_context) { pundit_context(user) }

    permissions :show? do
      it "grants access to any user" do
        expect(subject).to permit(policy_context, other_user)
        expect(subject).to permit(policy_context, user)
      end
    end

    permissions :update?, :show_protected_attributes?, :update_profile? do
      it "grants access to owner" do
        expect(subject).to permit(policy_context, user)
      end

      it "denies access to other user" do
        expect(subject).not_to permit(policy_context, other_user)
      end
    end

    permissions :update_protected_attributes? do
      it "denies access to non-admin" do
        expect(subject).not_to permit(policy_context)
      end
    end
  end

  context 'As an admin - Edit Mode: ON' do
    let(:policy_context) { pundit_context(admin, true) }

    permissions :show? do
      it "grants access to any user" do
        expect(subject).to permit(policy_context, other_user)
        expect(subject).to permit(policy_context, user)
      end
    end

    permissions :update?, :update_profile? do
      it "grants access to owner" do
        expect(subject).to permit(policy_context, admin)
      end

      it "grants access to admin" do
        expect(subject).to permit(policy_context, user)
      end
    end

    permissions :update_protected_attributes?, :show_protected_attributes? do
      it "grants access to admin" do
        expect(subject).to permit(policy_context)
      end
    end
  end


  context 'As an admin - Edit Mode: OFF' do
    let(:policy_context) { pundit_context(admin, false) }

    permissions :show? do
      it "grants access to any user" do
        expect(subject).to permit(policy_context, other_user)
        expect(subject).to permit(policy_context, user)
      end
    end

    permissions :update?, :update_profile? do
      it "grants access to owner" do
        expect(subject).to permit(policy_context, admin)
      end

      it "denies access to admin" do
        expect(subject).not_to permit(policy_context, user)
      end
    end

    permissions :show_protected_attributes? do
      it "grants access to admin" do
        expect(subject).to permit(policy_context, user)
      end
    end

    permissions :update_protected_attributes? do
      it "denies access to admin" do
        expect(subject).not_to permit(policy_context)
      end
    end
  end
end
