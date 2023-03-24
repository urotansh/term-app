class Public::UsersController < ApplicationController
  before_action :authenticate_user!, unless: :admin_signed_in?
  before_action :ensure_guest_user, only: [:edit]
  
  def show
    # ユーザー情報
    @user = User.find_by(name: params[:name])
    
    # ユーザー投稿一覧(サイドメニュー)
    @notes = @user.notes
    @favorite_notes = @user.favorite_notes
    
    # ユーザー投稿一覧(メインメニュー)
    @title = I18n.t("note.index")
    @notes_pagination = @notes.page(params[:page])
  end

  def edit
    @user = current_user
  end
  
  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      redirect_to settings_profile_users_path, notice: I18n.t("user.notice.update")
    else
      # レシーバのユーザ名が不正値でupdateされるため正常値へ戻す
      @user.name = current_user.name
      render :edit
    end
  end

  def quit
  end
  
  def withdraw
    @user = User.find(current_user.id)
    @user.update(is_deleted: true)
    reset_session
    redirect_to root_path, notice: I18n.t("user.notice.withdraw")
  end
  
  def following
    # フォロー
    @title = I18n.t("user.following")
    @user  = User.find_by(name: params[:name])
    @users = @user.following.page(params[:page])
    render 'show_follow'
  end

  def followers
    # フォロワー
    @title = I18n.t("user.followers")
    @user  = User.find_by(name: params[:name])
    @users = @user.followers.page(params[:page])
    render 'show_follow'
  end
  
  
  private
  
  def user_params
    params.require(:user).permit(:name, :image)
  end
  
  def ensure_guest_user
    @user = User.find(current_user.id)
    if @user.name == "guestuser"
      redirect_to user_path(current_user.name) , notice: I18n.t("user.notice.ensure_guest_user")
    end
  end
  
end
