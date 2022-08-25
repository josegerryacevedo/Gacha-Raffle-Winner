class Admins::ItemsController < AdminController
  before_action :set_item, only: [:edit, :update, :destroy]

  def index
    @items = Item.includes(:category)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admins_items_path, notice: 'Successfully Created!'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      redirect_to admins_items_path, notice: 'Successfully Updated!'
    else
      render :edit
    end
  end

  def destroy
    if @item.destroy
      redirect_to admins_items_path, notice: 'Successfully Deleted!'
    else
      redirect_to admins_items_path, alert: "This can't be deleted, it has record on bet!!"
    end
  end

  private

  def item_params
    params.require(:item).permit(:image, :name, :minimum_bets, :state, :batch_count, :online_at, :offline_at, :start_at, :status, :quantity, :category_id)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end