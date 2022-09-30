# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  def new
    super
    unless cookies[:promoter]
      cookies[:promoter] = params[:promoter]
    end
  end

  def create
    params[:user][:parent_id] = User.find_by_email(cookies[:promoter])&.id
    super
  end

  def edit
    super
  end

  def update
    form = params[:user]
    if form[:current_password].present? || form[:password].present? || form[:password_confirmation].present?
      update_with_password
    else
      update_user
    end
  end

  private

  def user_params
    params.require(:user).permit(:phone, :image, :username)
  end

  def password_params
    params.require(:user).permit(:phone, :image, :username, :current_password, :password, :password_confirmation)
  end

  def update_with_password
    if @user.update_with_password(password_params)
      flash[:notice] = "Successfully updated"
      sign_in @user, :bypass => true
      redirect_to users_profile_path
    else
      render :edit
    end
  end

  def update_user
    if @user.update(user_params)
      flash[:notice] = "Successfully updated"
      sign_in @user, :bypass => true
      redirect_to users_profile_path
    else
      render :edit
    end
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :parent_id)
  end
end
