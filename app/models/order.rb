class Order < ApplicationRecord
  belongs_to :purchase
  belongs_to :user
  has_many   :order_items, dependent: :destroy
  has_one    :payment, dependent: :destroy

  validates_uniqueness_of :purchase_id, scope: :user_id, message: "請勿重複訂單，請修改先前訂單"

  accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true

  after_save :update_purchase_total_price

  def update_purchase_total_price
    self.purchase.update(total_price: self.purchase.orders.pluck(:total_price).reduce(:+))
  end

  def update_payment_diff(o_price)
    o_diff = self.payment.diff
    self.payment.update(diff: o_diff + o_price - self.total_price)
  end


end
