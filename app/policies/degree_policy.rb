class DegreePolicy < ApplicationPolicy

  def create?
    owner? || admin_edit?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
