class ApplicationPolicy
  attr_reader :user, :record, :edit_mode

  def initialize(user_context, record)
    @user      = user_context.user
    @edit_mode = user_context.edit_mode
    @record    = record
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def admin?
    user && user.admin?
  end

  def owner?
    record.user == user
  end

  def owner_or_admin?
    admin? || owner?
  end

  def admin_edit?
    admin? && edit_mode
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  class UserContext
    attr_reader :user, :edit_mode

    def initialize(user, edit_mode)
      @user      = user
      @edit_mode = edit_mode
    end
  end
end
