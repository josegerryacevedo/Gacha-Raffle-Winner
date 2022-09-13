class Admins::NewsTickersController < AdminController
  before_action :set_news_ticker, except: [:index, :new, :create]

  def index
    @news_tickers = NewsTicker.includes(:admin)
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def create
    @news_ticker = NewsTicker.new(news_ticker_params)
    @news_ticker.admin = current_admins_user
    if @news_ticker.save
      redirect_to admins_news_tickers_path, notice: 'Successfully Created!'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @news_ticker.update(news_ticker_params)
      redirect_to admins_news_tickers_path, notice: 'Successfully Updated!'
    else
      render :edit
    end
  end

  def destroy
    if @news_ticker.destroy
      flash[:notice] = "Successfully Deleted!"
    else
      flash[:alert] = "Deleted Failed!"
    end
    redirect_to admins_news_tickers_path
  end

  private

  def news_ticker_params
    params.require(:news_ticker).permit(:content, :status)
  end

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id])
  end
end