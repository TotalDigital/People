require 'rails_helper'
require 'pundit/rspec'

RSpec.describe RelationshipPolicy, type: :policy do
  subject { described_class }

  let(:user) { create(:user, role: "basic") }
  let(:target) { create(:user, role: "basic") }
  let(:admin) { create(:user, role: "admin") }

  context 'As a user' do
    let(:policy_context) { pundit_context(user) }
    let(:relationship) { build(:relationship, user: user) }
    let(:other_relationship) { build(:relationship) }
    let(:nil_relationship) { build(:relationship, target: nil) }
    let(:redundant_relationship) { build(:relationship, user: user, target: user) }
    let!(:existing_relationship) { create(:relationship, user: user, target: target) }

    permissions :new?, :create? do
      it "grants access if user is owner of relationship" do
        expect(subject).to permit(policy_context, relationship)
      end

      it "denies access if user not owner of relationship" do
        expect(subject).not_to permit(policy_context, other_relationship)
      end

      it "denies access if relationship target is empty" do
        expect(subject).not_to permit(policy_context, nil_relationship)
      end

      it "denies access if relationship target user is the same as owner" do
        expect(subject).not_to permit(policy_context, redundant_relationship)
      end

      it "denies access if relationship already exists between user & target" do
        expect(subject).not_to permit(policy_context, existing_relationship)
      end
    end

    permissions :destroy? do
      let(:relationship) { create(:relationship, user: user) }
      let(:other_relationship) { create(:relationship) }

      it "grants access if user is owner of relationship" do
        expect(subject).to permit(policy_context, relationship)
      end

      it "denies access if user not owner of relationship" do
        expect(subject).not_to permit(policy_context, other_relationship)
      end
    end

    permissions :kind_available? do
      let(:user_source) { create(:user, internal_id: 'J0123456') }
      let(:user_target) { create(:user, internal_id: 'J0123457') }
      let(:external_user) { create(:user, internal_id: 'L0123456') }

      let(:policy_context_admin) { pundit_context(admin, true) }
      let(:policy_context_total_user) { pundit_context(user_source) }
      let(:policy_context_external_user) { pundit_context(external_user) }

      let(:relationship_user_source) { create(:relationship, user: user_source, target: user_target) }
      let(:relationship_external_user_source) { create(:relationship, user: external_user, target: user_target) }

      it "grants access to all kinds of relations as an admin edit mode enabled" do
        Relationship::KINDS.keys.each do |kind|
          relationship_user_source.kind = kind
          expect(subject).to permit(policy_context_admin, relationship_user_source)
          expect(subject).to permit(policy_context_admin, relationship_external_user_source)
        end
      end

      it "grants access to all kinds of relations as a user" do
        Relationship::KINDS.keys.each do |kind|
          relationship_user_source.kind = kind
          expect(subject).to permit(policy_context_total_user, relationship_user_source)
        end
      end
    end
  end

  context 'As an admin, edit mode : ON' do
    let(:policy_context) { pundit_context(admin, true) }
    let(:relationship) { build(:relationship, user: user) }
    let(:other_relationship) { build(:relationship) }
    let(:nil_relationship) { build(:relationship, target: nil) }
    let(:redundant_relationship) { build(:relationship, user: user, target: user) }
    let!(:existing_relationship) { create(:relationship, user: user, target: target) }

    permissions :new?, :create? do
      it "grants access for relationship between any user" do
        expect(subject).to permit(policy_context, relationship)
      end

      it "denies access if relationship target is empty" do
        expect(subject).not_to permit(policy_context, nil_relationship)
      end

      it "denies access if relationship target user is the same as owner" do
        expect(subject).not_to permit(policy_context, redundant_relationship)
      end

      it "denies access if relationship already exists between user & target" do
        expect(subject).not_to permit(policy_context, existing_relationship)
      end
    end

    permissions :destroy? do
      let(:relationship) { create(:relationship, user: user) }
      let(:other_relationship) { create(:relationship) }

      it "grants access for relationship between any user" do
        expect(subject).to permit(policy_context, relationship)
      end
    end
  end
end
