# frozen_string_literal: true

class MenusController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :set_menu, only: [:show, :edit, :update, :destroy, :publish, :archive]

  def index
    @menus = @restaurant.menus.includes(:dishes).ordered
    @menus = @menus.where(status: params[:status]) if params[:status].present?
    @menus = @menus.where(menu_type: params[:menu_type]) if params[:menu_type].present?
  end

  def show
    @dishes = @menu.dishes.includes(:menu).ordered
    @dishes = @dishes.where(status: params[:dish_status]) if params[:dish_status].present?
    @dishes = @dishes.where(category: params[:category]) if params[:category].present?
  end

  def new
    @menu = @restaurant.menus.build
  end

  def create
    @menu = @restaurant.menus.build(menu_params)
    
    if @menu.save
      redirect_to [@restaurant, @menu], notice: 'Menu was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @menu.update(menu_params)
      redirect_to [@restaurant, @menu], notice: 'Menu was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @menu.destroy
    redirect_to restaurant_menus_path(@restaurant), notice: 'Menu was successfully deleted.'
  end

  def publish
    if @menu.publish!
      redirect_to [@restaurant, @menu], notice: 'Menu was successfully published.'
    else
      redirect_to [@restaurant, @menu], alert: 'Menu cannot be published. Please add at least one published dish.'
    end
  end

  def archive
    @menu.archive!
    redirect_to [@restaurant, @menu], notice: 'Menu was successfully archived.'
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurants.find(params[:restaurant_id])
  end

  def set_menu
    @menu = @restaurant.menus.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(
      :name, :description, :menu_type, :status, :position
    )
  end
end
