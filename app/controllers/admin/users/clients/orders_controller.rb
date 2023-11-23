class Admin::Users::Clients::OrdersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_client
  before_action :set_order_instance

  def new_increase
    @order.genre = 'increase'
  end

  def new_deduct
    @order.genre = 'deduct'
  end

  def new_bonus
    @order.genre = 'bonus'
  end

  def create_increase

  end

  def create_deduct

  end

  def create_bonus

  end

  private

  def set_client
    @client = User.client.find(params[:client_user_id])
  end

  def set_order_instance
    @order = @client.orders.build
  end
end
