class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      case
      when sys_admin? || admin?
        scope.all
      when user.present?
        scope.where(id: user.id)
      else
        scope.none
      end
    end
  end

  def read?
    own_user? || sys_admin? || admin?
  end

  def change?
    own_user? || sys_admin? || admin?
  end

  def add?
    true
  end

  def delete?
    sys_admin?
  end

  private
  def target_user
    record
  end

  def own_user?
    user.present? && target_user == user
  end
end
