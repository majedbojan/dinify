# frozen_string_literal: true

class DishesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :set_menu
  before_action :set_dish, only: [:show, :edit, :update, :destroy, :publish, :archive]

  def index
    @dishes = @menu.dishes.ordered
    @dishes = @dishes.where(status: params[:status]) if params[:status].present?
    @dishes = @dishes.where(category: params[:category]) if params[:category].present?
  end

  def show
  end

  def new
    @dish = @menu.dishes.build
  end

  def create
    @dish = @menu.dishes.build(dish_params)
    
    if @dish.save
      redirect_to [@restaurant, @menu, @dish], notice: 'Dish was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @dish.update(dish_params)
      redirect_to [@restaurant, @menu, @dish], notice: 'Dish was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @dish.destroy
    redirect_to restaurant_menu_dishes_path(@restaurant, @menu), notice: 'Dish was successfully deleted.'
  end

  def publish
    @dish.update!(status: :published)
    redirect_to [@restaurant, @menu, @dish], notice: 'Dish was successfully published.'
  end

  def archive
    @dish.update!(status: :archived)
    redirect_to [@restaurant, @menu, @dish], notice: 'Dish was successfully archived.'
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurants.find(params[:restaurant_id])
  end

  def set_menu
    @menu = @restaurant.menus.find(params[:menu_id])
  end

  def set_dish
    @dish = @menu.dishes.find(params[:id])
  end

  def dish_params
    params.require(:dish).permit(
      :name, :description, :price, :category, :image_url, :calories,
      :protein, :carbs, :fat, :fiber, :sodium, :sugar, :allergens,
      :ingredients, :status, :position
    )
  end
end
