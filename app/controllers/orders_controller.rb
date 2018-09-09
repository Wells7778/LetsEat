class OrdersController < ApplicationController

  def index
    @purchases = current_user.order_purchases.includes(:menu).uniq
  end

  def create
    @order = current_user.orders.build(order_params)
    @order.total_price = update_total_price
    if @order.save
      flash[:notice] = "已訂購，總金額共#{@order.total_price}"
      redirect_to root_path
    else
      flash[:alert] = @order.errors.full_messages.to_sentence
      redirect_to root_path
    end
  end

  def update
    @order = Purchase.find_by(id: params[:id]).orders.find_by(user_id: current_user.id)
    @order.total_price = update_total_price
    if @order.update(order_params)
      flash[:notice] = "修改訂購，總金額共#{@order.total_price}"
      redirect_to root_path
    else
      flash[:alert] = @order.errors.full_messages.to_sentence
      render "purchases#edit_order"
    end
  end

  def destroy

  end
  private

  # 更新訂單總價
  def update_total_price
    result = 0
    order_params[:order_items_attributes].to_h.each_value do |item|
      result += item[:price].to_i * item[:qty].to_i
    end
    return result
  end

  def order_params
    params.require(:order).permit(:purchase_id,
                                  :total_price,
                                  order_items_attributes: [:id,
                                                           :name,
                                                           :price,
                                                           :qty,
                                                           :note,
                                                           :_destroy])
  end
end
