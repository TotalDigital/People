class ProjectParticipationPolicy < ApplicationPolicy

  def new?
    owner? || admin_edit?
  end

  def create?
    ( owner? || admin_edit? ) && users_same_scope
  end

  def update?
    owner? || admin_edit?
  end

  def destroy?
    update?
  end

  def users_same_scope
    record.user.scope == record.project.user.scope
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
