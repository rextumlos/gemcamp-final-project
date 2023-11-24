module Admin::BannersHelper
  def active_banners
    @active_banners ||= Banner.active
                              .where("online_at <= ? AND offline_at > ?", Time.current, Time.current)
                              .order(created_at: :desc)
  end
end
