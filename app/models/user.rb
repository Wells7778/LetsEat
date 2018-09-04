class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :purchases
  has_many :orders

  validates :email, uniqueness: true
  validates :code_number, uniqueness: true

  ROLE = {
    normal: "一般用戶",
    admin: "管理者"
  }

  def admin?
    self.role == "admin"
  end

end
