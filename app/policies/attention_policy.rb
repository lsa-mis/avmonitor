class AttentionPolicy < ApplicationPolicy

  def index?
    user_in_access_group?
  end

end
