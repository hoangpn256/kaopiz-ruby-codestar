class UsersController < ApplicationController
  before_action 
  def index
    @users = User.all
  end

  def create 
    @user = User.new(user_params)
    
    if @user.save
    redirect_to users_path, notice: "da tao"
    end
  end

  def show
  end

  def edit
  end

  def new
    @user = User.new
  end
  private

  def user_params
    params.require(:user).permit(:name, :email, :gender, :language, :phone,:dob, :address, :vacine)
  end


end
