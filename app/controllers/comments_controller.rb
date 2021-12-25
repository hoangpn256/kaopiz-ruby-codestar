class CommentsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
    before_action :find_commentable, only: :create
    def new
        @comment = Comment.new
    end

    def create
        @comment = @commentable.comments.new(comment_params)
        @comment.user = current_user
        if @comment.save
          if @commentable.class == Article
          respond_to do |format|
            format.html {  redirect_to @commentable }
            format.js
          end 
          elsif @commentable.class == Comment
              respond_to do |format|
                format.html {  redirect_to @commentable.commentable }
                format.js
              end 
          end

        else
          redirect_to @commentable, alert: "Something went wrong"
        end
    end

    def edit

    end

    def update

    end

    def destroy
      @comment = @commentable.comments.find(params[:id])
      @comment.destroy
      redirect_to @commentable
    end

    def index

    end

    def show

    end

    private

    def comment_params
        params.require(:comment).permit(:content)
    end

    def find_commentable
      if params[:comment_id]
        @commentable = Comment.find_by_id(params[:comment_id]) 
      elsif params[:article_id]
        @commentable = Article.find_by_id(params[:article_id])
      end
    end

end
