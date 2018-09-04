class Order < ApplicationRecord
  belongs_to :purchase
  belongs_to :user
  has_many   :order_items, dependent: :destroy

  accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true

  after_save :update_purchase_total_price

  def update_purchase_total_price
    self.purchase.update(total_price: self.purchase.orders.pluck(:total_price).reduce(:+))
  end

end
