class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :destroy]
  before_action :set_path_param_name, only: [:create, :destroy]
  
  def create
    current_user.follow(@user)
  end

  def destroy
    current_user.unfollow(@user)
  end
  
  private
  
  def set_user
    @user = User.find_by(name: params[:user_name])
  end
  
  def set_path_param_name
    # パスパラメータ(ユーザー名)を変数へ格納
    # Rails.application.routes.recognize_path(path, environment = {})
    # => コントローラー, アクション, パスパラメータをハッシュで返却
    # => {:controller=>"public/users", :action=>"show", :name=>"test1"}
    # request.referrer
    # => リクエスト元URL
    @path_param_name = Rails.application.routes.recognize_path(request.referrer)[:name]
  end
  
end
