# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    if params[:user][:current_password].present?
      update_with_password
    else
      update_user
    end
    redirect_to client_root_path
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:phone, :username, :image])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

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
    else
      flash[:alert] = "Error"
    end
  end

  def update_user
    if @user.update(user_params)
      flash[:notice] = "Successfully updated"
      sign_in @user, :bypass => true
    else
      flash[:alert] = "Error"
    end
  end
end
