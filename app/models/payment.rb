class Payment < ApplicationRecord
  belongs_to :order

  validates_presence_of :price

  after_create :update_order_paidte
  private
  def update_order_paid
    self.order.update(is_paid: true)
  end

end
