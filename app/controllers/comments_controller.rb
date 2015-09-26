class CommentsController < ApplicationController
  load_and_authorize_resource

  def create
    @snippet = Snippet.find(params[:snippet_id])
    @comment = @snippet.comments.create(comment_params)
    @comment.user = current_user
    @comment.save

    respond_to do |format|
      if @comment.save
        format.html { redirect_to snippet_path(@snippet) }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
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
      params.require(:comment).permit(:body_md, :snippet_id)
    end
end
