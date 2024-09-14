class CommentsController < ApplicationController
  def pending_approvals
    comments = current_user.super_admin? ? Comment.sadmin_pending_approvals : Comment.admin_pending_approvals
    @comments = comments.includes(:comment_by, :story)
  end

  def approve_comment
    comment = Comment.find params[:comment_id]
    render json: { success: true, message: 'Comment not found.' }, status: 404 and return if comment.nil?

    update_params = current_user.super_admin? ? { approved_by_sadmin: true } : { approved_by_admin: true }
    if comment.update(update_params)
      render json: { success: true, message: 'Comment approved successfully.' }
    else
      render json: { success: false, message: 'Failed to approve comment.' }, status: 422
    end
  end

  def submit_comment
    comment = Comment.create!(validate_and_build_submit_params)
    p comment.errors
    if comment.errors.blank?
      render json: { success: true, message: 'Comment added successfully, wait for comment approval by admin.' }
    else
      render json: { success: false, message: 'Failed to add comment.', errors: comment.errors.full_messages }, status: 422
    end
  end

  private

  def validate_and_build_submit_params
    story = Story.find params[:story_id]
    render json: { success: false, message: "Story not found!"}, status: 404 and return if story.nil?

    { story_id: story.id, comment_by: current_user, content: params[:comment], approved_by_admin: false, approved_by_sadmin: false }
  end
end
