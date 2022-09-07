class Users::OrdersController < ApplicationController
  before_action :set_order

  def cancel
    if @order.cancel!
      flash[:notice] = "Successfully Cancelled!"
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to users_profile_path
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end
end