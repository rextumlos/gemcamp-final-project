class Admin::NewsTickersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_news_ticker, except: [:index, :new, :create]

  def index
    @news_tickers = NewsTicker.all.includes(:admin).page(params[:page]).per(5)
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def create
    @news_ticker = NewsTicker.new(news_ticker_params)
    @news_ticker.admin = current_admin_user
    if @news_ticker.save
      flash[:notice] = 'NewsTicker saved!'
      redirect_to news_tickers_path
    else
      flash.now[:alert] = 'NewsTicker saving failed.'
      render :new
    end
  end

  def edit
  end

  def update
    if @news_ticker.update(news_ticker_params)
      flash[:notice] = 'NewsTicker updated!'
      redirect_to news_tickers_path
    else
      flash.now[:alert] = 'NewsTicker update failed.'
      render :edit
    end
  end

  def destroy
    @news_ticker.destroy
    flash[:notice] = 'NewsTicker deleted.'
    redirect_to news_tickers_path
  end

  private

  def news_ticker_params
    params.require(:news_ticker).permit(:content, :status)
  end

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id])
  end
end
