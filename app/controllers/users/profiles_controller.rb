class Users::ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @orders = Order.where(user: current_user).order(id: :desc) if params[:history] == 'order' || params[:history].blank?
    @bets = Bet.includes(:item).where(user: current_user).order(id: :desc) if params[:history] == 'bet'
    @invites = User.where(parent: current_user).order(id: :desc) if params[:history] == 'invite'
    @winners = Winner.includes(:item, :bet).where(user: current_user).order(id: :desc) if params[:history] == 'winner'
  end
end
