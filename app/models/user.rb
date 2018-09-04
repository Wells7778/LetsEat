class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :purchases
  has_many :orders

  has_many :order_purchases, through: :orders, source: :purchase

  validates :email, uniqueness: true
  validates :code_number, uniqueness: true

  ROLE = {
    normal: "一般用戶",
    admin: "管理者"
  }

  def admin?
    self.role == "admin"
  end

  def has_order?(purchase)
    purchase.orders.pluck(:user_id).include?(self.id)
  end
end
