class RoomPolicy < ApplicationPolicy

  def index?
    user_in_access_group?
  end

  def show?
    user_in_access_group?
  end

  def new?
    create?
  end

  def create?
    user.role == 'admin'
  end

  def edit?
    update?
  end

  def update?
    user.role == 'admin'
  end

  def destroy?
    user.role == 'admin'
  end

  def refresh_room?
    user.role == 'admin'
  end

end
