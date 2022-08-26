class DashboardController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!

  def index
    rooms = Room.active
    @rooms = rooms_need_attention(rooms)
    authorize :dashboard
  end

end
