class JobPolicy < ApplicationPolicy
  def new?
    create?
  end

  def create?
    owner? || admin_edit?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def import_list?
    user.admin?
  end
end
