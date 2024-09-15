module CommentsConcerns
  include ActiveSupport::Concern

  protected

  def build_submit_params
    { story_id: @story.id, comment_by: current_user, content: params[:comment],
      approved_by_admin: false, approved_by_sadmin: false }
  end

  def validate_params
    @story = Story.find params[:story_id]
    render json: { success: false, message: "Story not found!"}, status: 404 and return if @story.nil?
  end

  def set_comment
    @comment = Comment.find params[:comment_id]
    render json: { success: true, message: 'Comment not found.' }, status: 404 and return if @comment.nil?
  end
end
