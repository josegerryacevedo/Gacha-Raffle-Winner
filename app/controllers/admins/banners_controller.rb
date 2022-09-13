class Admins::BannersController < AdminController
  before_action :set_banner, except: [:index, :new, :create]

  def index
    @banners = Banner.all
  end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      redirect_to admins_banners_path, notice: 'Successfully Created!'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @banner.update(banner_params)
      redirect_to admins_banners_path, notice: 'Successfully Updated!'
    else
      render :edit
    end
  end

  def destroy
    if @banner.destroy
      flash[:notice] = "Successfully Deleted!"
    else
      flash[:alert] = "Deleted Failed!"
    end
    redirect_to admins_banners_path
  end

  private

  def banner_params
    params.require(:banner).permit(:preview, :online_at, :offline_at, :status)
  end

  def set_banner
    @banner = Banner.find(params[:id])
  end
end
