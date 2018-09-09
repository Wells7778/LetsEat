class PaymentsController < ApplicationController
  before_action :set_order

  def create
    @payment = @order.build_payment(payment_params)
    @payment.diff = @payment.price - @order.total_price
    if @payment.save
      flash[:notice] = "已付款 ＄#{@payment.price}"
    else
      flash[:alert] = @payment.errors.full_messages.to_sentence
    end
    redirect_to show_orders_purchase_path(@order.purchase)
  end


  private
  def set_order
    @order = Order.find(params[:order_id])
  end

  def payment_params
    params.require(:payment).permit(:price, :diff)
  end

end
