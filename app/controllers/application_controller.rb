class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, :if => :skip_authentication_stories

  private

  # skip authentication check for root_path
  def skip_authentication_stories
    false if action_name == 'index' && controller_name == 'stories'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role, :active])
  end

  # raise unauthorization error if user does not have access
  rescue_from CanCan::AccessDenied do |exception|
    if request.xhr?
      render json: { message: 'Please signin to continue.' }, status: :forbidden
    else
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

end
