class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, only: :json_request?
  # before_action :set_locale

  def after_sign_in_path_for(resource)
    root_path
  end

  private

  # def set_locale
  #   I18n.locale =
  #     %w(ru en).include?(params[:locale]) ? params[:locale] : I18n.default_locale
  # end

  def json_request?
    request.format.json?
  end
end
