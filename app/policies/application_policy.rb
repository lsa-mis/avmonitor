# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
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

  def user_in_access_group?
    if user.role == ''
      return false
    end
    access_groups = ['LSA-AV-Monitoring-Admins', 'lsa-av-monitoring-tech', 'LSA-AV-Monitoring-Viewer']
    user.membership && (user.membership & access_groups).any?
  end

end
