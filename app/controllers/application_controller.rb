class ApplicationController < ActionController::Base
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

  def after_sign_out_path_for(resource_or_scope)
    # You can change this to any path you want, such as:
    # new_user_session_path, or some other custom page
    root_path  # By default, this redirects to the root of the application
  end

end
