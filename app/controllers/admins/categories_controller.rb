class Admins::CategoriesController < AdminController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admins_categories_path, notice: 'Successfully Created!'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to admins_categories_path, notice: 'Successfully Updated!'
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    if @category.deleted_at
      redirect_to admins_categories_path,  notice: 'Successfully Deleted!'
    else
      redirect_to admins_categories_path,  alert: 'This cant be deleted, it has record on item!!'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end