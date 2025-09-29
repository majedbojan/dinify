# frozen_string_literal: true

class PublicMenusController < ApplicationController
  before_action :set_restaurant
  before_action :set_menu, only: [:show_menu]

  def show
    @menus = @restaurant.menus.published.includes(:dishes).ordered
    @featured_menu = @menus.first
  end

  def show_menu
    @dishes = @menu.dishes.published.ordered
    @dishes_by_category = @dishes.group_by(&:category)
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_menu
    @menu = @restaurant.menus.published.find(params[:menu_id])
  end
end
