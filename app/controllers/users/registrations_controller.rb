# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  def new
    super
    unless cookies[:promoter]
      cookies[:promoter] = params[:promoter]
    end
  end

  def create
    build_resource(sign_up_params)
    resource.parent_id = User.find_by_email(cookies[:promoter])&.id
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
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
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end
end
