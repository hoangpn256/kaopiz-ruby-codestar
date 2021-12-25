class UsersController < ApplicationController
  before_action :find_user, only: [:show]

  def show
    @profile = @user.profile
    @profile ||= Profile.new

  end

  def index

  end

  private

  def find_user
    @user = User.find_by(id: params[:id])
  end

end
