# frozen_string_literal: true

class Admins::SessionsController < Devise::SessionsController

  # POST /resource/sign_in
  def create
    user_admin = User.find_for_authentication(email: params[:admins_user][:email])
    if user_admin&.client? && user_admin&.valid_password?(params[:admins_user][:password])
      flash[:notice] = "You don't have permission"
      redirect_to action: :new
    else
      super
    end
  end
end
