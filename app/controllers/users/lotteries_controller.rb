class Users::LotteriesController < ApplicationController
  before_action :set_item, only: :create
  before_action :authenticate_user!, only: :create

  def index
    @items = Item.active.starting
    @items = @items.includes(:category).where(category: { name: params[:category] }) if params[:category]
    @categories = Category.all
  end

  def show
    if @items = Item.active.starting.find_by_id(params[:id])
      @item = Item.find(params[:id])
      @current_bets = @item.bets.where(user: current_user).where(batch_count: @item.batch_count)
      @bet = Bet.new
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end

  def create
    begin
      count = params[:bet][:coins].to_i
      params[:bet][:coins] = 1
      params[:bet][:item_id] = @item.id
      ActiveRecord::Base.transaction do
        count.times do
          @bet = Bet.new(bet_params)
          @bet.user = current_user
          @bet.batch_count = @item.batch_count
          @bet.save!
        end
      end
      flash[:notice] = "Successfully Bet!"
    rescue ActiveRecord::RecordInvalid => exception
      flash[:alert] = exception
    end
    redirect_to users_lottery_path (@item)
  end

  private

  def bet_params
    params.require(:bet).permit(:item_id, :coins)
  end

  def set_item
    @item = Item.find(params[:bet][:item_id])
  end
end
