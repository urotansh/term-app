class ApplicationController < ActionController::Base
  around_action :switch_locale
  
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
  
  def switch_locale(&action)
    locale = params[:lang] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
  
  def default_url_options
    { lang: I18n.locale }
  end
end
