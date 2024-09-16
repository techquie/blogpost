class StoriesController < ApplicationController
  load_and_authorize_resource

  ###### controller ACTIONS ######
  def index
    @stories = Story.includes(:user).limit(10)
  end

  def show
    @story = Story.find_by id: show_params[:id]
    @comments = Comment.approved_comments.where(story_id: @story.id).includes(:comment_by)
  end

  private

  def show_params
    params.permit(:id)
  end
end
