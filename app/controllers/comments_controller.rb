class CommentsController < ApplicationController
  before_action :require_login, only: [:create]

  def create
    @snippet = Snippet.find(params[:snippet_id])
    @comment = @snippet.comments.create(comment_params)
    @comment.user = current_user
    @comment.save

    redirect_to snippet_path(@snippet)
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
