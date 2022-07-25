class NotePolicy < ApplicationPolicy
  
  def index?
    user_in_access_group?
  end

  def show?
    user_in_access_group?
  end

  def create?
    ["admin", "technician"].include?(user.role)
  end

  def update?
    ["admin", "technician"].include?(user.role)
  end

  def destroy?
    ["admin", "technician"].include?(user.role)
  end

end
