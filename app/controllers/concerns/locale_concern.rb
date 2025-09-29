module LocaleConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_locale
    helper_method :current_locale, :available_locales, :switch_locale_path, :rtl_locale?, :text_direction
  end

  def current_locale
    I18n.locale
  end

  def available_locales
    Rails.application.config.i18n.available_locales || [ :en, :ar ]
  end

  def rtl_locale?
    %w[ar he fa ur].include?(current_locale.to_s)
  end

  def text_direction
    rtl_locale? ? 'rtl' : 'ltr'
  end

  def switch_locale_path(locale)
    url_for(locale: locale, **request.query_parameters)
  end

  private

  def set_locale
    I18n.locale = locale_from_params || locale_from_cookie || I18n.default_locale
    cookies[:locale] = I18n.locale
  end

  def locale_from_params
    return nil unless params[:locale].present?
    return params[:locale].to_sym if I18n.available_locales.include?(params[:locale].to_sym)
    nil
  end

  def locale_from_cookie
    return nil unless cookies[:locale].present?
    return cookies[:locale].to_sym if I18n.available_locales.include?(cookies[:locale].to_sym)
    nil
  end
end
