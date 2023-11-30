class Admin::MemberLevelsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_member_level, except: [:index, :new, :create]

  def index
    @member_levels = MemberLevel.all.page(params[:page]).per(5)
  end

  def new
    @member_level = MemberLevel.new
  end

  def create
    @member_level = MemberLevel.new(member_level_params)
    if @member_level.save
      flash[:notice] = 'Member level created successfully'
      redirect_to member_levels_path
    else
      flash.now[:alert] = 'Member level creation failed.'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @member_level.update(member_level_params)
      flash[:notice] = 'Member level update successfully'
      redirect_to member_levels_path
    else
      flash.now[:alert] = 'Member level update failed.'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @member_level.destroy
    flash[:notice] = 'Member level deleted'
    redirect_to member_levels_path
  end

  private

  def member_level_params
    params.require(:member_level).permit(:level, :required_members, :coins)
  end

  def set_member_level
    @member_level = MemberLevel.find(params[:id])
  end
end
