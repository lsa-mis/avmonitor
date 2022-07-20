class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_in_group
  before_action :set_membership
  after_action :verify_authorized, unless: :devise_controller?

  private

  def user_not_authorized
    flash[:alert] = "Please sign in to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def user_not_in_group
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to about_path
  end

  def set_membership
    if user_signed_in?
      current_user.membership = session[:user_memberships]
      current_user.role = session[:user_role]
    else
      new_user_session_path
    end
  end

end
