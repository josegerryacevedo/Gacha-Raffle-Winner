class Users::ShareFeedbacksController < ApplicationController
  before_action :set_winner, only: :show

  def index
    @winners = Winner.published.includes(:user)
  end

  def show; end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end
end