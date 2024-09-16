module CommentsConcerns
  include ActiveSupport::Concern

  protected

  def build_submit_params
    { story_id: @story.id, comment_by: current_user, content: submit_comment_params[:comment],
      approved_by_admin: false, approved_by_sadmin: false }
  end

  def validate_params
    @story = Story.find_by id: submit_comment_params[:story_id]
    render json: { success: false, message: "Story not found!"}, status: 404 and return if @story.nil?
  end

  def set_comment
    @comment = Comment.find_by id: approve_comment_params[:comment_id]
    render json: { success: false, message: 'Comment not found.' }, status: 404 and return if @comment.nil?
  end
end
