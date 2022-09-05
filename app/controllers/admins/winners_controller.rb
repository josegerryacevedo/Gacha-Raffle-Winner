class Admins::WinnersController < AdminController
  before_action :set_winner, except: :index

  def index
    @winners = Winner.includes(:user, :item, :bet, :address)
    @winners = @winners.where(bet: { serial_number: params[:serial_number] }) if params[:serial_number].present?
    @winners = @winners.where(user: { email: params[:email] }) if params[:email].present?
    @winners = @winners.where(item: { name: params[:product_name] }) if params[:product_name].present?
    @winners = @winners.where(state: params[:state]) if params[:state].present?
    @winners = @winners.where(created_at: params[:start].to_datetime..params[:end].to_datetime) if params[:start].present? && params[:end].present?
  end

  def submit
    if @winner.submit!
      flash[:notice] = "Successfully Submitted!"
    else
      flash[:alert] = @winner.errors.full_messages.join(', ')
    end
    redirect_to admins_winners_path
  end

  def pay
    if @winner.pay!
      flash[:notice] = "Successfully Paid!"
    else
      flash[:alert] = @winner.errors.full_messages.join(', ')
    end
    redirect_to admins_winners_path
  end

  def ship
    if @winner.ship!
      flash[:notice] = "Successfully Shipped!"
    else
      flash[:alert] = @winner.errors.full_messages.join(', ')
    end
    redirect_to admins_winners_path
  end

  def deliver
    if @winner.deliver!
      flash[:notice] = "Successfully Delivered!"
    else
      flash[:alert] = @winner.errors.full_messages.join(', ')
    end
    redirect_to admins_winners_path
  end

  def publish
    if @winner.publish!
      flash[:notice] = "Successfully Published!"
    else
      flash[:alert] = @winner.errors.full_messages.join(', ')
    end
    redirect_to admins_winners_path
  end

  def remove_publish
    if @winner.remove_publish!
      flash[:notice] = "Successfully Remove Published!"
    else
      flash[:alert] = @winner.errors.full_messages.join(', ')
    end
    redirect_to admins_winners_path
  end

  private

  def set_winner
    @winner = Winner.find(params[:winner_id])
  end
end