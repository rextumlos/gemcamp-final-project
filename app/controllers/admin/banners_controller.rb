class Admin::BannersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_banner, except: [:index, :new, :create]

  def index
    @banners = Banner.all.page(params[:page]).per(5)
  end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      flash[:notice] = 'Banner saved!'
      redirect_to banners_path
    else
      flash.now[:alert] = 'Banner saving failed.'
      render :new
    end
  end

  def edit
  end

  def update
    if @banner.update(banner_params)
      flash[:notice] = 'Banner updated!'
      redirect_to banners_path
    else
      flash.now[:alert] = 'Banner update failed.'
      render :edit
    end
  end

  def destroy
    @banner.destroy
    flash[:notice] = 'Banner deleted.'
    redirect_to banners_path
  end

  private

  def banner_params
    params.require(:banner).permit(:preview, :online_at, :offline_at, :status)
  end

  def set_banner
    @banner = Banner.find(params[:id])
  end
end
