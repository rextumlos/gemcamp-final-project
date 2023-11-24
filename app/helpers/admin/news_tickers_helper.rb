module Admin::NewsTickersHelper
  def active_news_tickers
    @active_news_tickers ||= NewsTicker.active.order(created_at: :desc).limit(5)
  end
end
