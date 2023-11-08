class Client::AddressController < ApplicationController
  before_action :authenticate_client_user!

  def index
  end
end
