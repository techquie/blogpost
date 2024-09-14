class ApplicationController < ActionController::Base
  load_and_authorize_resource
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, :if => :skip_authentication_stories

  private

  def skip_authentication_stories
    false if action_name == 'index' && controller_name == 'stories'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role, :active])
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: 'You are not authorized to perform this action.'
  end

end
