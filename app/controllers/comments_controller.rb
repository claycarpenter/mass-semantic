class CommentsController < ApplicationController
  load_and_authorize_resource

  def create
    @snippet = Snippet.find(params[:snippet_id])
    @comment = @snippet.comments.create(comment_params)
    @comment.user = current_user
    @comment.save

    redirect_to snippet_path(@snippet)
  end

  def destroy
    # Find comment
    comment = Comment.find(params[:id])

    # Verify comment author is current user. If not, redirect to login.
    unless comment.user = current_user
      flash[:error] = "You don't have permission to delete that comment."
      redirect_to login_path

      return
    end

    # Delete comment
    comment.delete

    # Redirect user back to parent snippet
    redirect_to snippet_path(comment.snippet)
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
