class CommentsController < ApplicationController
  load_and_authorize_resource

  # POST /snippets/1/comments
  # POST /snippets/1/comments.json
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

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to snippet_path(@comment.snippet) }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    respond_to do |format|
      if @comment.destroy
        format.html { redirect_to snippet_path(@comment.snippet) }
        format.json { head :no_content }
      else
        format.html { render :delete }
        format.json { render json: @snippet.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body_md)
    end
end
