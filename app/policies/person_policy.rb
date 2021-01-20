class PersonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      case
      when sys_admin? || admin?
        original_scope.all
      when user.present?
        original_scope.where(user_id: user.id)
      else
        original_scope.none
      end
    end
  end

  def read?
    own_person? || sys_admin? || admin?
  end

  def change?
    own_person? || sys_admin? || admin?
  end

  def add?
    own_person? || sys_admin?
  end

  def delete?
    sys_admin?
  end

  private

  def person
    record
  end

  def own_person?
    person.user_id == user&.id
  end
end