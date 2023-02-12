class ApplicationController < ActionController::Base
  before_action :authenticate_admin!, except: :top, if: :admin_url
  before_action :set_locale, if: :inspect_lang_params
  
  def admin_url
    request.fullpath.include?("/admin")
  end
  
  def after_sign_in_path_for(resource)
    admin_users_path
  end
  
  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admin_path
    when User
      root_path
    end
  end

  def after_sign_out_path_for(resource)
    case resource
    when :admin
      new_admin_session_path
    when :user
      root_path
    end
  end
  
  private
  
  def set_locale
    I18n.locale = params[:lang].to_sym
  end
  
  def inspect_lang_params
    if params[:lang].present? && params[:lang].to_sym.in?(I18n::available_locales)
      return true
    else
      return false
    end
  end
  
end
