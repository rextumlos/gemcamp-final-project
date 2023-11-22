class Admin::Users::AdminsController < ApplicationController
  before_action :authenticate_admin_user!

  def index
    @admins = User.admin
  end
end
