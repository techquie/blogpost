module UsersConcerns
  extend ActiveSupport::Concern

  def set_user
    @user = User.find params[:user_id]
  end

  # verify the eligibility to block/unblock a user
  def eligibile_block?
    return current_user.admin? || current_user.super_admin?

    redirect_to users_path, notice: "You are not authorized to perform the action!"
  end

  # check user accessibility for users list
  def verify_authorisation
    redirect_to root_path, notice: "You are not authorized to view this page!" if current_user&.visitor?
  end
end
