require 'rails_helper'
require 'pundit/rspec'

RSpec.describe LanguagePolicy, type: :policy do
  subject { described_class }

  let(:user) { FactoryGirl.create(:user, role: "basic") }
  let(:admin) { FactoryGirl.create(:user, role: "admin") }
  let(:language) { FactoryGirl.create(:language) }

  permissions :index?, :new?, :create? do
    it "grants access to any user" do
      expect(subject).to permit(pundit_context(user))
      expect(subject).to permit(pundit_context(admin))
    end
  end

  permissions :edit?, :update?, :destroy? do
    it "grants access if user is an admin" do
      expect(subject).to permit(pundit_context(admin), language)
    end
    it "denies access if user is an basic user" do
      expect(subject).not_to permit(pundit_context(user), language)
    end
  end
end
