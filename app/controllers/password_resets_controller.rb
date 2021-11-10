class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
  only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "flash.email_reset"
      redirect_to root_url
    else
      flash.now[:danger] = t "flash.not_found_email"
      render :new
    end
  end

  def update
    if user_params[:password].empty?
      @user.errors.add :password, t("errors.messages.blank")
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "flash.reset_password_successed"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]

    return if @user

    flash[:danger] = t "flash.login.invalid_email"
    redirect_to root_path
  end

  def valid_user
    if @user.authenticated?(:reset, params[:id])
      return if @user.activated?

      flash[:danger] = t "flash.login.invalid_activate"
    else
      flash[:danger] = t "flash.invalid_link"
    end
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "flash.password_reset_expired"
    redirect_to new_password_reset_url
  end
end
