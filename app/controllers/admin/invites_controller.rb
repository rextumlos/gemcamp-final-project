class Admin::InvitesController < ApplicationController
  def index
    @invites = User.where.not(parent_id: nil).includes(:parent)

    if params[:search].present?
      @invites = @invites.joins("JOIN users parents ON parents.id = users.parent_id").where("parents.email LIKE :search", search: "%#{params[:search]}%")
    end

    @invites = @invites.page(params[:page]).per(5)
  end
end
