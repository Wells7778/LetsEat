class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy, :edit_order, :show_orders]

  def index
    @purchases = Purchase.enable.page(params[:page]).per(10)
    @categories = Category.all
  end

  def show
    @menu = @purchase.menu
    @products = @menu.products
    @order = Order.new
  end

  def new
    @purchase = current_user.purchases.new
  end

  def create
    @purchase = current_user.purchases.new(purchase_params)
    if @purchase.save
      flash[:notice] = " #{@purchase.name} 開團成功，#{@purchase.deadline.strftime("%Y-%m-%d %H:%M")} 截止"
      redirect_to root_path
    else
      flash.now[:alert] = @purchase.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @purchase.update(purchase_params)
      flash[:notice] = " #{@purchase.name} 修改成功，#{@purchase.deadline.strftime("%Y-%m-%d %H:%M")} 截止"
      redirect_to root_path
    else
      flash.now[:alert] = @purchase.errors.full_messages.to_sentence
      render :new
    end
  end

  def destroy
    if @purchase.owner?(current_user) || current_user.admin?
      @purchase.destroy
      redirect_to root_path
    else
      flash[:alert] = "不是你開的團無法刪除喔！"
      redirect_to root_path
    end
  end

  def edit_order
    if current_user.has_order?(@purchase)
      @menu = @purchase.menu
      @products = @menu.products
      @order = @purchase.orders.find_by(user_id: current_user.id)
    else
      flash[:alert] = "尚未訂餐，請點選訂餐"
      redirect_to root_path
    end
  end

  def show_orders
    @orders = @purchase.orders.includes(:order_items, :user)
  end

  private

  def purchase_params
    params.require(:purchase).permit(:open_date, :name, :deadline, :menu_id, :is_enable, :total_price)
  end

  def set_purchase
    @purchase = Purchase.find_by(id: params[:id])
  end

end