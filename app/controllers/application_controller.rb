class ApplicationController < ActionController::Base
  before_action :authenticate_admin!, except: :top, if: :admin_url

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
  
end
