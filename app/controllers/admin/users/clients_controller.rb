class Admin::Users::ClientsController < ApplicationController
  before_action :authenticate_admin_user!

  def index
    @clients = User.client
  end
end
