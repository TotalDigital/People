require 'rails_helper'
require 'pundit/rspec'

RSpec.describe SkillPolicy, type: :policy do
  subject { described_class }

  let(:user) { FactoryGirl.create(:user, role: "basic") }
  let(:admin) { FactoryGirl.create(:user, role: "admin") }
  let(:skill) { FactoryGirl.create(:skill) }

  permissions :edit?, :update?, :destroy? do
    it "grants access if user is an admin" do
      expect(subject).to permit(pundit_context(admin), skill)
    end
    it "denies access if user is a basic user" do
      expect(subject).not_to permit(pundit_context(user), skill)
    end
  end

end
