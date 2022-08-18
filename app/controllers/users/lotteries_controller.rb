class Users::LotteriesController < ApplicationController
  def lottery
    @items = Item.active.starting
    @items = @items.includes(:category).where(category: {name: params[:category]}) if params[:category]
    @categories = Category.all
  end
end
