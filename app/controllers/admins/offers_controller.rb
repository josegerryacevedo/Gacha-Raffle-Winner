class Admins::OffersController < AdminController
  before_action :offer_item, only: [:edit, :update, :destroy]

  def index
    @offers = Offer.all
    @offers = @offers.where(status: params[:status]) if params[:status].present?
    @offers = @offers.where(genre: params[:genre]) if params[:genre].present?
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      flash[:notice] = "Successfully Created!"
      redirect_to admins_offers_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @offer.update(offer_params)
      flash[:notice] = "Successfully Updated!"
      redirect_to admins_offers_path
    else
      render :edit
    end
  end

  def destroy
    if @offer.destroy
      flash[:notice] = "Successfully Deleted!"
    else
      flash[:alert] = "Deleted Failed!"
    end
    redirect_to admins_offers_path
  end

  private

  def offer_params
    params.require(:offer).permit(:image, :name, :genre, :status, :amount, :coin)
  end

  def offer_item
    @offer = Offer.find(params[:id])
  end
end
