# frozen_string_literal: true

module Ui
  class ButtonComponent < ViewComponent::Base
    VARIANTS = {
      primary: 'bg-blue-600 hover:bg-blue-700 text-white',
      secondary: 'bg-gray-600 hover:bg-gray-700 text-white',
      success: 'bg-green-600 hover:bg-green-700 text-white',
      danger: 'bg-red-600 hover:bg-red-700 text-white',
      warning: 'bg-yellow-600 hover:bg-yellow-700 text-white',
      info: 'bg-cyan-600 hover:bg-cyan-700 text-white',
      outline: 'border-2 border-blue-600 text-blue-600 hover:bg-blue-600 hover:text-white',
      ghost: 'text-blue-600 hover:bg-blue-100',
      link: 'text-blue-600 hover:text-blue-800 underline'
    }.freeze

    SIZES = {
      sm: 'px-3 py-1.5 text-sm',
      md: 'px-4 py-2 text-base',
      lg: 'px-6 py-3 text-lg',
      xl: 'px-8 py-4 text-xl'
    }.freeze

    def initialize(
      variant: :primary,
      size: :md,
      type: :button,
      disabled: false,
      loading: false,
      icon: nil,
      icon_position: :left,
      class: '',
      **html_attributes
    )
      @variant = variant
      @size = size
      @type = type
      @disabled = disabled
      @loading = loading
      @icon = icon
      @icon_position = icon_position
      @class = binding.local_variable_get(:class)
      @html_attributes = html_attributes
    end

    private

    attr_reader :variant, :size, :type, :disabled, :loading, :icon, :icon_position, :class, :html_attributes

    def button_classes
      base_classes = [
        'inline-flex items-center justify-center font-medium rounded-md transition-colors duration-200',
        'focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500',
        'disabled:opacity-50 disabled:cursor-not-allowed',
        VARIANTS[variant],
        SIZES[size]
      ]

      base_classes << class if class.present?
      base_classes.join(' ')
    end

    def disabled?
      disabled || loading
    end

    def show_icon?
      icon.present? && !loading
    end

    def icon_classes
      case icon_position
      when :left
        'mr-2'
      when :right
        'ml-2'
      else
        ''
      end
    end

    def loading_spinner
      content_tag(:svg, class: 'animate-spin -ml-1 mr-2 h-4 w-4 text-current', fill: 'none', viewBox: '0 0 24 24') do
        content_tag(:circle, '', class: 'opacity-25', cx: '12', cy: '12', r: '10', stroke: 'currentColor', 'stroke-width': '4')
        content_tag(:path, '', class: 'opacity-75', fill: 'currentColor', d: 'M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z')
      end
    end
  end
end
