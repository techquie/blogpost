class StoriesController < ApplicationController
  def index
    @stories = Story.includes(:user).limit(10)
  end

  def show
    @story = Story.find params[:id]
    @comments = Comment.approved_comments.where(story_id: @story.id).includes(:comment_by)
  end
end
