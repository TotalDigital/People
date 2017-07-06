class ProjectPolicy < ApplicationPolicy

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
    owner? || admin_edit?
  end

  def destroy?
    update?
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
      elsif user.test?
        scope.test_only
      else
        scope.none
      end
    end
  end
end
