class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy, :edit_order, :show_orders, :close]

  def index
    @purchases = Purchase.enable.page(params[:page]).per(10)
    @categories = Category.all
  end

  def show
    if @purchase.is_enable
      @menu = @purchase.menu
      @products = @menu.products
      @order = Order.new
    else
      flash[:alert] = "此團已結束"
      redirect_to root_path
    end
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
    if @purchase.is_enable
      if current_user.has_order?(@purchase)
        @menu = @purchase.menu
        @products = @menu.products
        @order = @purchase.orders.find_by(user_id: current_user.id)
      else
        flash[:alert] = "尚未訂餐，請點選訂餐"
        redirect_to root_path
      end
    else
      flash[:alert] = "此團已關閉"
      redirect_to root_path
    end
  end

  def show_orders
    if @purchase.owner?(current_user) || current_user.has_order?(@purchase)
      @orders = @purchase.orders.includes(:order_items, :user)
      @order_items = @purchase.order_items.pluck(:name, :note, :qty)
      @total_items = {}
      @order_items.each do |item|
        if @total_items[item.first].nil?
          if item.second.blank?
            @total_items[item.first] = ["正常", item.last]
          else
            @total_items[item.first] = [item.second, item.last]
          end
        else
          @total_items[item.first][1] += item.last
          if item.second.blank?
            @total_items[item.first][0] += "& 正常"
          else
            @total_items[item.first][0] += "& #{item.second}"
          end
        end
      end
      puts @total_items
    else
      flash[:alert] = "非開團者或未定餐"
      redirect_to root_path
    end
  end

  def close
    if @purchase.owner?(current_user)
      @purchase.close
      flash[:notice] = "已關閉訂餐"
      redirect_to show_orders_purchase_path(@purchase)
    else
      flash[:alert] = "這不是你開的團喔"
      redirect_to root_path
    end
  end

  def my
    @purchases = current_user.purchases.includes(:menu)
  end

  private

  def purchase_params
    params.require(:purchase).permit(:open_date, :name, :deadline, :menu_id, :is_enable, :total_price)
  end

  def set_purchase
    @purchase = Purchase.find_by(id: params[:id])
  end

end