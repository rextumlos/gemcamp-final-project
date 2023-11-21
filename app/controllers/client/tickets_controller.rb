class Client::TicketsController < ApplicationController
  before_action :authenticate_client_user!
  before_action :set_item
  before_action :is_user_coins_enough?

  def create
    num_of_tickets = params[:tickets].to_i

    if num_of_tickets <= 0
      flash[:alert] = 'Number of tickets must be greater than zero.'
      redirect_to lottery_path(@item) and return
    end

    num_of_tickets.times do
      ticket = @item.tickets.build
      ticket.user = current_client_user
      ticket.batch_count = @item.batch_count

      unless ticket.save
        flash[:alert] = ticket.errors.full_messages
        redirect_to lottery_path(@item) and return
      end
    end

    redirect_to lottery_path(@item)
  end

  private

  def set_item
    @item = Item.find(params[:item])
    unless @item
      flash[:alert] = 'Invalid item.'
      redirect_to lottery_index_path
    end
  end

  def is_user_coins_enough?
    return if params[:tickets].present? && params[:tickets].to_i <= current_client_user.coins
    flash[:alert] = 'Invalid ticket request.'
    redirect_to lottery_path(@item) and return
  end
end
