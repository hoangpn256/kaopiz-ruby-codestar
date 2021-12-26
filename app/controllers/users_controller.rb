class UsersController < ApplicationController
  before_action :find_user, only: [:show,:follow,:unfollow]

  def show
    @profile = @user.profile
    @profile ||= Profile.new

  end

  def index
    if !params[:user_ids].blank?
    @users = User.where(id: params[:user_ids])
    render "index"
    end
  end

  def follow
    if !current_user.followings.include?(@user) 
      Follow.create(follower_id: current_user.id, followed_id: @user.id)
    end
    render "follow.js.erb"
  end

  def unfollow
    if current_user.followings.include?(@user) 
      @follow = Follow.find_by(follower_id: current_user.id, followed_id: @user.id)
      @follow.destroy
    end
    render "follow.js.erb"
  end


  private

  def find_user
    @user = User.find_by(id: params[:id])
  end

end
