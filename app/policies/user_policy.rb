class UserPolicy < ApplicationPolicy

  PROTECTED_ATTRIBUTES = People.protected_attributes

  def index?
    user
  end

  def show?
    user
  end

  def update?
    record == user || admin_edit?
  end

  def update_attribute?(attribute)
    if PROTECTED_ATTRIBUTES.include?(attribute)
      update_protected_attributes?
    else
      user.respond_to?(attribute) && update?
    end
  end

  def destroy?
    record == user || admin?
  end

  def import_list?
    user.admin?
  end

  def update_profile?
    update?
  end

  def show_protected_attributes?
    record == user || admin?
  end

  def update_protected_attributes?
    admin_edit?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user_context, scope)
      @user  = user_context.user
      @scope = scope
    end

    def resolve
      if user.blank?
        scope.none
      elsif user.people?
        scope.people
      elsif user.test_only?
        scope.test_only
      else
        scope.none
      end
    end
  end

end
