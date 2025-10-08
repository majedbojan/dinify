# frozen_string_literal: true

module Menus
  class DishCardComponent < ViewComponent::Base
    def initialize(dish:, show_actions: true, current_user: nil, show_nutrition: true)
      @dish = dish
      @show_actions = show_actions
      @current_user = current_user
      @show_nutrition = show_nutrition
    end

    private

    attr_reader :dish, :show_actions, :current_user, :show_nutrition

    def can_edit?
      return false unless current_user
      
      current_user.can_manage_restaurant?(dish.restaurant)
    end

    def status_badge_class
      case dish.status
      when 'published'
        'bg-green-100 text-green-800'
      when 'draft'
        'bg-yellow-100 text-yellow-800'
      when 'archived'
        'bg-gray-100 text-gray-800'
      else
        'bg-gray-100 text-gray-800'
      end
    end

    def status_text
      dish.status.humanize
    end

    def category_badge_class
      case dish.category
      when 'appetizer'
        'bg-orange-100 text-orange-800'
      when 'soup'
        'bg-blue-100 text-blue-800'
      when 'salad'
        'bg-green-100 text-green-800'
      when 'main'
        'bg-purple-100 text-purple-800'
      when 'side'
        'bg-yellow-100 text-yellow-800'
      when 'dessert'
        'bg-pink-100 text-pink-800'
      when 'beverage'
        'bg-cyan-100 text-cyan-800'
      when 'alcoholic_beverage'
        'bg-red-100 text-red-800'
      else
        'bg-gray-100 text-gray-800'
      end
    end

    def category_text
      dish.category.humanize
    end

    def has_nutritional_info?
      dish.nutritional_info_complete?
    end

    def allergen_icons
      return [] unless dish.has_allergens?
      
      dish.allergen_list.map do |allergen|
        case allergen.downcase
        when 'gluten'
          { icon: 'fas fa-wheat', class: 'text-amber-600', title: 'Contains Gluten' }
        when 'dairy', 'milk'
          { icon: 'fas fa-cow', class: 'text-blue-600', title: 'Contains Dairy' }
        when 'nuts', 'peanuts'
          { icon: 'fas fa-seedling', class: 'text-green-600', title: 'Contains Nuts' }
        when 'eggs'
          { icon: 'fas fa-egg', class: 'text-yellow-600', title: 'Contains Eggs' }
        when 'soy'
          { icon: 'fas fa-leaf', class: 'text-green-700', title: 'Contains Soy' }
        when 'fish', 'seafood'
          { icon: 'fas fa-fish', class: 'text-blue-700', title: 'Contains Fish/Seafood' }
        when 'shellfish'
          { icon: 'fas fa-shrimp', class: 'text-orange-600', title: 'Contains Shellfish' }
        else
          { icon: 'fas fa-exclamation-triangle', class: 'text-red-600', title: "Contains #{allergen}" }
        end
      end
    end
  end
end
