class Client::HomeController < ApplicationController
  before_action :authenticate_client_user!
  def index
    @winners_feedback = Winner.published.order(created_at: :desc).limit(5)
    @active_lotteries = Item.active.starting.order(created_at: :desc).limit(8)
  end
end
