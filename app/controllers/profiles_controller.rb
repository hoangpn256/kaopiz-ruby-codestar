class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show edit update destroy ]
  before_action :save_session_url
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  def index
    @profiles = Profile.all
  end

  def show
    @user = User.find_by(id: params[:user_id])
  end

  def create
   
    @profile = current_user.build_profile(profile_params)
    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile.user, notice: 'Tạo mới thành công.' }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @profile = Profile.new
  end

  def edit
  end

  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile.user, notice: 'Update thành công.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def profile_params
    params.require(:profile).permit(:name, :dob, :phone, :avatar)
  end

  def save_session_url
    if !current_user
      session[:fall_back_url] = request.url
    end
  end

end
