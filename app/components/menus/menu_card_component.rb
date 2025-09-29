# frozen_string_literal: true

module Menus
  class MenuCardComponent < ViewComponent::Base
    def initialize(menu:, show_actions: true, current_user: nil)
      @menu = menu
      @show_actions = show_actions
      @current_user = current_user
    end

    private

    attr_reader :menu, :show_actions, :current_user

    def can_edit?
      return false unless current_user
      
      current_user.can_manage_restaurant?(menu.restaurant)
    end

    def status_badge_class
      case menu.status
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
      menu.status.humanize
    end

    def menu_type_badge_class
      case menu.menu_type
      when 'breakfast'
        'bg-orange-100 text-orange-800'
      when 'lunch'
        'bg-blue-100 text-blue-800'
      when 'dinner'
        'bg-purple-100 text-purple-800'
      when 'brunch'
        'bg-pink-100 text-pink-800'
      when 'drinks'
        'bg-cyan-100 text-cyan-800'
      when 'desserts'
        'bg-pink-100 text-pink-800'
      when 'seasonal'
        'bg-green-100 text-green-800'
      when 'special'
        'bg-red-100 text-red-800'
      else
        'bg-gray-100 text-gray-800'
      end
    end

    def menu_type_text
      menu.menu_type.humanize
    end
  end
end
