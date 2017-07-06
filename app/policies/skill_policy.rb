class SkillPolicy < ApplicationPolicy

  def index?
    user
  end

  def new?
    user
  end

  def create?
    user
  end

  def edit?
    update?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end
end
