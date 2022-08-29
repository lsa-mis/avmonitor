class DashboardController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!

  def index
    
    rooms = Room.active
    @rooms = rooms_need_attention(rooms)
    authorize :dashboard
  
    if params["commit"] == "Refresh"
      render turbo_stream: turbo_stream.replace(
        :dashboard_listing,
        partial: "dashboard/listing"
      )
    end
  end

end
