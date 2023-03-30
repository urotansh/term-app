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
    locale = available_locale(params[:lang]) || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
  
  # ロケールがavailable_localesに含まれているか確認し、結果に応じて locale または nil を返す
  # presence_in: 引数の配列の中に値が存在する場合、それ自身を返す
  def available_locale(lang)
    lang.to_sym.presence_in(I18n::available_locales) || nil
  end
  
  def default_url_options
    { lang: I18n.locale }
  end
end
