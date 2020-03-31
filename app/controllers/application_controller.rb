class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale

  helper_method :current_user, :logged_in?

  def logged_in?
    session[:user_id].present?
  end

  def ensure_authenticated
    redirect_to login_path, alert: t('alerts.not_logged_in') unless logged_in?
  end

  def current_user
    if @current_user.present?
      return @current_user
    end
    @current_user = User.find(session[:user_id]) if logged_in?
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
