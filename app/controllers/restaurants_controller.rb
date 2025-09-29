# frozen_string_literal: true

class RestaurantsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

  def index
    @restaurants = current_user.restaurants.includes(:menus)
    @restaurants = @restaurants.where(status: params[:status]) if params[:status].present?
    @restaurants = @restaurants.by_name(params[:search]) if params[:search].present?
  end

  def show
    @menus = @restaurant.menus.includes(:dishes).ordered
    @recent_menus = @menus.limit(5)
    @menu_stats = {
      total_menus: @menus.count,
      published_menus: @menus.published.count,
      total_dishes: @menus.joins(:dishes).count,
      published_dishes: @menus.joins(:dishes).where(dishes: { status: :published }).count
    }
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    
    if @restaurant.save
      # Add current user as admin
      @restaurant.restaurant_users.create!(
        user: current_user,
        role: 'admin',
        status: 'active'
      )
      
      redirect_to @restaurant, notice: 'Restaurant was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @restaurant.update(restaurant_params)
      redirect_to @restaurant, notice: 'Restaurant was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @restaurant.destroy
    redirect_to restaurants_url, notice: 'Restaurant was successfully deleted.'
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurants.find(params[:id])
  end

  def restaurant_params
    params.require(:restaurant).permit(
      :name, :description, :phone, :email, :address, :website, :status
    )
  end
end
