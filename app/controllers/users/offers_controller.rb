class Users::OffersController < ApplicationController
  before_action :set_order, only: :order
  before_action :authenticate_user!, only: :order

  def index
    @offers = Offer.active
  end

  def order
    @order = Order.new
    @order.genre = :deposit
    @order.amount = @offer.amount
    @order.coin = @offer.coin
    @order.user = current_user
    @order.offer = @offer
    if @order.save
      if @order.may_submit? && @order.submit!
        flash[:notice] = "Order successfully!"
      else
        flash[:alert] = @order.errors.full_messages.join(', ')
      end
      redirect_to users_offers_path
    else
      render :index
    end
  end

  private

  def set_order
    @offer = Offer.active.find(params[:offer_id])
  end
end