class ArticlesController < ApplicationController
    before_action :set_article, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
    before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :upvote , :downvote]
    after_action :count_viewed, only: :show
    
    
    def upvote

        if current_user.voted_up_on? @article
          @article.unvote_by current_user
        else
          @article.upvote_by current_user
        end
        render "vote.js.erb"

    end
  
    def downvote
      
        if current_user.voted_down_on? @article
          @article.unvote_by current_user
        else
          @article.downvote_by current_user
        end
        render "vote.js.erb"
      
    end

def index
    @articles = Article.published.order("created_at DESC")
end

def own_articles
    @articles = current_user.articles.order("created_at DESC")
    render "index"
end

def trending_articles
  @articles = Article.published.order("created_at DESC, viewed DESC")
  render "index"
end

def tag_articles
  @articles = Article.joins(:tags).where("tags.name = ?", params[:tag]).published.order("created_at DESC")
  render "index"
end

def show

end





def new
    @article = Article.new
end

def create
 
    @article = current_user.articles.new(article_params.except(:tags))
    if params["article"][:tags] != nil and params["article"][:tags] != []
      params["article"][:tags].shift()
      params["article"][:tags].each do |t|
        tag = Tag.find_or_create_by(name: t)
        @article.tags << tag
      end  
    end

    respond_to do |format|
        if @article.save
          format.html { redirect_to @article, notice: 'Tạo mới thành công.' }
          format.json { render :show, status: :created, location: @article }
        else
          format.html { render :new }
          format.json { render json: @article.errors, status: :unprocessable_entity }
        end
      end
end

def edit

end

def update
  if params["article"][:tags] != nil and params["article"][:tags] != []
    params["article"][:tags].shift()
    params["article"][:tags].each do |t|
      tag = Tag.find_or_create_by(name: t)
      @article.tags << tag
    end  
  end
    respond_to do |format|
        if @article.update(article_params.except(:tags))
          format.html { redirect_to @article, notice: 'Update thành công.' }
          format.json { render :show, status: :ok, location: @article }
        else
          format.html { render :edit }
          format.json { render json: @article.errors, status: :unprocessable_entity }
        end
      end
end

def destroy
    @article.destroy
    respond_to do |format|
        format.html { redirect_to own_articles_articles_path, notice: 'Đã xóa.' }
        format.json { head :no_content }
      end
end

private

def set_article
    @article = Article.find_by(id: params[:id])
end
# tags_attributes: [:name, ]
def article_params
    arti_params = params.require(:article).permit(:title, :body, :user_id, :viewed, :status, tags: [])
    arti_params[:status] = params[:article][:status].to_i
    return arti_params
end

def count_viewed
  set_article
  @article.viewed += 1
  @article.save
end



end
