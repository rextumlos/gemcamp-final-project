class Client::Me::InvitesController < ApplicationController
  def index
    @invites = current_client_user.children
                                  .order(created_at: :desc)
                                  .page(params[:page]).per(5)
  end
end
