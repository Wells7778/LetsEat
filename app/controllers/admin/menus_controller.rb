class Admin::MenusController < Admin::BaseController
  before_action :set_menu, except: [:index, :new, :create]
  def index
    @menus = Menu.all
    if params[:id]
      @menu = Menu.find_by(id: params[:id])
    else
      @menu = Menu.new
    end
  end

  def new
    @menu = Menu.new
  end

  def create
    @menu = Menu.new(menu_params)
    if @menu.save
      flash[:notice] = "新增菜單 #{@menu.name}"
      redirect_to admin_menus_path
    else
      flash.now[:alert] = @menu.errors.full_messages.to_sentence
      @menus = Menu.all
      @menu = Menu.new
      render :index
    end
  end

  def show
    @products = @menu.products
  end

  def update
    if @menu.update(menu_params)
      flash[:notice] = "更新菜單 #{@menu.name}"
      redirect_to admin_menus_path
    else
      flash.now[:alert] = @menu.errors.full_messages.to_sentence
      @menus = Menu.all
      @menu = Menu.new
      render :index
    end
  end

  def destroy
    @menu.destroy
    redirect_to admin_menus_path
  end


  private
  def menu_params
    params.require(:menu).permit(:name, :file_location, :description, :phonenumber ,:category_id, products_attributes: [:id, :name, :price, :_destroy])
  end

  def set_menu
    @menu = Menu.find_by(id: params[:id])
  end

end
