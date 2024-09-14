class UsersController < ApplicationController
  include UsersConcerns

  ###### CALLBACKS ######
  before_action :set_user, only: [:block_unblock_user]
  before_action :eligibile_block?, only: [:block_unblock_user]
  before_action :verify_authorisation

  ###### controller ACTIONS ######
  def index
    @users = User.all
  end

  #
  def block_unblock_user
    render json: { success: false, message: "can't block/unblock ownself." }, status: 403 and return if current_user.id == @user.id

    if @user.update(active: !@user.active)
      action = @user.active ? 'unblocked' : 'blocked'
      render json: { success: true, message: "#{@user.name} is #{action} successfully.", active: @user.active }
    else
      render json: { success: false, message: 'Error occured while blocking/unblocking user.' }, status: 422
    end
  end
end
