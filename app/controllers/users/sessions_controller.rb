# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    user = User.find_for_authentication(email: params[:user][:email])
    if user&.admin? && user&.valid_password?(params[:user][:password])
      flash[:notice] = "You don't have permission"
      redirect_to action: :new
    else
      super
    end
  end
end
