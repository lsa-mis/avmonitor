class DashboardController < ApplicationController
  include ApplicationHelper

  def index
   rooms =  Room.active
    @rooms = rooms_need_attention(rooms)
  end
end
