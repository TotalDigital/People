class OnboardingPolicy < ApplicationPolicy

  def index?
    user
  end
end
