class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:update, :destroy]

  def index
    @categories = Category.all
    if params[:id]
      @category = Category.find_by(id: params[:id])
    else
      @category = Category.new
    end
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "新增分類 #{@category.name}"
      redirect_to admin_categories_path
    else
      flash.now[:alert] = @category.errors.full_messages.to_sentence
      @categories = Category.all
      @category = Category.new
      render :index
    end
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "更新分類 #{@category.name}"
      redirect_to admin_categories_path
    else
      flash.now[:alert] = @category.errors.full_messages.to_sentence
      @categories = Category.all
      render :index
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find_by(id: params[:id])
  end
end
