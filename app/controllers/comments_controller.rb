class CommentsController < ApplicationController
  include CommentsConcerns
  load_and_authorize_resource

  ###### CALLBACKS ######
  before_action :validate_params, only: [:submit_comment]
  before_action :set_comment, only: [:approve_comment]

  ###### controller ACTIONS ######
  def pending_approvals
    comments = current_user.super_admin? ? Comment.sadmin_pending_approvals : Comment.admin_pending_approvals
    @comments = comments.includes(:comment_by, :story)
  end

  def approve_comment
    update_params = current_user.super_admin? ? { approved_by_sadmin: true } : { approved_by_admin: true }
    if @comment.update(update_params)
      render json: { success: true, message: 'Comment approved successfully.' }
    else
      render json: { success: false, message: 'Failed to approve comment.' }, status: 422
    end
  end

  def submit_comment
    comment = Comment.create(build_submit_params)
    if comment.errors.blank?
      render json: { success: true, message: 'Comment added successfully, wait for comment approval by admin.' }
    else
      render json: { success: false, message: 'Failed to add comment.', errors: comment.errors.full_messages }, status: 422
    end
  end

  private

  def submit_comment_params
    params.permit(:story_id, :comment)
  end

  def approve_comment_params
    params.permit(:comment_id)
  end
end
