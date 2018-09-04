class Purchase < ApplicationRecord
  belongs_to :menu
  belongs_to :user
  has_one    :order_list
  has_many   :orders

  validates_presence_of :name, :open_date, :deadline, :menu

  scope :enable, -> { where(is_enable: true)}
  scope :expired, -> { where(is_enable: false) }

  after_create :create_order_list
  def owner?(user)
    self.user_id == user.id
  end
end
