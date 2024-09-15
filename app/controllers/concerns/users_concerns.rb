module UsersConcerns
  extend ActiveSupport::Concern

  def set_user
    @user = User.find_by id: params[:user_id]
  end

  # verify the eligibility to block/unblock a user
  def eligibile_block?
    return current_user.admin? || current_user.super_admin?

    redirect_to users_path, notice: "You are not authorized to perform the action!"
  end
end
