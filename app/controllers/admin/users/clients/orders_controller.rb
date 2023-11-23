class Admin::Users::Clients::OrdersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_client
  before_action :set_new_order_instance, only: [:new_increase, :new_bonus, :new_deduct]

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
    @order = @client.orders.build(order_params)
    @order.genre = 'increase'

    if @order.save
      flash[:notice] = 'Increase balance added.'
      redirect_to client_users_path
    else
      flash.now[:alert] = 'Increase balance failed.'
      render :new_increase
    end
  end

  def create_deduct
    @order = @client.orders.build(order_params)
    @order.genre = 'deduct'

    if @order.save
      flash[:notice] = 'Deduct balance added.'
      redirect_to client_users_path
    else
      flash.now[:alert] = 'Deduct balance failed.'
      render :new_deduct
    end
  end

  def create_bonus
    @order = @client.orders.build(order_params)
    @order.genre = 'bonus'

    if @order.save
      flash[:notice] = 'Bonus balance added.'
      redirect_to client_users_path
    else
      flash.now[:alert] = 'Bonus balance failed.'
      render :new_bonus
    end
  end

  private

  def set_client
    @client = User.client.find(params[:client_user_id])
  end

  def set_new_order_instance
    @order = @client.orders.build
  end

  def order_params
    params.require(:order).permit(:genre, :coin, :remarks )
  end
end
