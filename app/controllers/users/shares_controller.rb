class Users::SharesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_winner

  def show; end

  def update
    if @winner.share! && @winner.update(winner_params)
      flash[:notice] = "Successfully Shared!"
    else
      flash[:alert] = "Failed to share!"
    end
    redirect_to users_profile_path
  end

  private

  def set_winner
    @winner = Winner.where(user: current_user).find(params[:id])
  end

  def winner_params
    params.require(:winner).permit(:comment, :picture)
  end
end