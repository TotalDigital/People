class RelationshipPolicy < ApplicationPolicy

  def new?
    create?
  end

  def create?
     !target.nil? && owner_or_admin_edit? && users_same_scope && !redundant_relationship? && !relation_exists?
  end

  def destroy?
    owner? || target? || admin_edit?
  end

  def target
    record.target
  end

  def target?
    record.target == user
  end

  def owner
    record.user
  end

  def owner_or_admin_edit?
    owner? || admin_edit?
  end

  def redundant_relationship?
    target == owner
  end

  def relation_exists?
    owner.has_relation_with?(target)
  end

  def kind_available?
    admin_edit? || !external_user_involved || Relationship::KIND_PERMISSIONS_EXTERNAL[record.kind.to_sym]
  end

  def external_user_involved
    owner.external || target.external
  end

  def users_same_scope
    owner.scope == target.scope
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
