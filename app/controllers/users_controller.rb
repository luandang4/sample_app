class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update,
  :destroy,:following, :followers]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    @microposts = @user.microposts.paginate(page: params[:page])
    return if @user.present?

    flash[:danger] = t "flash.danger"
    redirect_to login_url
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "flash.info"
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      flash[:success] = t "flash.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit; end

  def destroy
    user = User.find_by(id: params[:id])
    if user&.destroy
      flash[:success] = t "flash.user_deleted"
    else
      flash[:danger] = t "flash.delete_fail"
    end
    redirect_to users_url
  end

  def following
    @title = t "flash.follow_title"
    @user = User.find_by(id: params[:id])
    @users = @user.following
    .paginate(page: params[:page])
    render :show_follow
  end

  def followers
    @title = t "flash.follower_title"
    @user = User.find_by(id: params[:id])
    @users = @user.followers
    .paginate(page: params[:page])
    render :show_follow
  end

  private

  def user_params
    params
      .require(:user).permit :name, :email, :password, :password_confirmation
  end

  def correct_user
    @user = User.find_by(id: params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
