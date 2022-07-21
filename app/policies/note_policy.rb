class NotePolicy < ApplicationPolicy
  
  def index?
    user_in_access_group?
  end

  def show?
    user_in_access_group?
  end

  def create?
    user_in_access_group?
  end

  def update?
    user_in_access_group?
  end

  def destroy?
    user.admin
  end

end
