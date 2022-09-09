class Admins::OrdersController < AdminController
  before_action :set_order, except: :index

  def index
    @orders = Order.includes(:user, :offer)
    @total_coin = @orders.sum(:coin)
    @total_amount = @orders.sum(:amount)
    @orders = @orders.where(serial_number: { serial_number: params[:serial_number] }) if params[:serial_number].present?
    @orders = @orders.where(user: { email: params[:email] }) if params[:email].present?
    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?
    @orders = @orders.where(state: params[:state]) if params[:state].present?
    @orders = @orders.where(offer: params[:offer]) if params[:offer].present?
    @orders = @orders.where(created_at: params[:start].to_datetime..params[:end].to_datetime) if params[:start].present? && params[:end].present?
    @subtotal_coin = @orders.sum(:coin)
    @subtotal_amount = @orders.sum(:amount)
  end

  def pay
    if @order.may_pay?
      flash[:notice] = "Successfully Paid!"
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to admins_orders_path
  end

  def cancel
    if @order.may_cancel?
      flash[:notice] = "Successfully Cancelled!"
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to admins_orders_path
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end
end