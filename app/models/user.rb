class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { client: 0, admin: 1 }

  validates :username, presence: true
  validates :phone, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }

  mount_uploader :image, ImageUploader

  belongs_to :parent, class_name: 'User', optional: true, counter_cache: :children_members
  has_many :children, class_name: 'User', foreign_key: 'parent_id'
  has_many :addresses
  has_many :tickets
  has_many :winning_items, class_name: 'Winner', foreign_key: 'user_id'
  has_many :bought_items, class_name: 'Winner', foreign_key: 'admin_id'
  has_many :orders
  has_many :news_tickers

  belongs_to :member_level, optional: true

  scope :with_children_total_deposit, -> {
    joins("LEFT JOIN users AS children ON children.parent_id = users.id")
      .group("users.id")
      .select("users.*, COALESCE(SUM(children.total_deposit), 0) AS children_total_deposit")
  }

  def upgrade_member_level
    find_member_level = MemberLevel.where("required_members <= ?", children_members).last

    if find_member_level.present? && find_member_level.level != member_level
      previous_member_level = MemberLevel.find_by_level(member_level)

      if previous_member_level
        previous_member_level.user_ids.delete(id)
        previous_member_level.save
      end

      if update(member_level: find_member_level)
        order = orders.build do |o|
          o.coin = find_member_level.coins
          o.genre = 'member_level'
        end

        order.save
      end
    end
  end

end
