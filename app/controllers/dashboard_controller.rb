class DashboardController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!

  def index
   authorize :dashboard
  end

end
