class Admin::UsersController < ApplicationController
  before_action :set_q, only: [:index, :search]
  
  def index
    @users = User.page(params[:page])
  end

  def edit
    @user = User.find_by(name: params[:name])
  end
  
  def update
    @user = User.find_by(name: params[:name])
    if @user.update(user_params)
      redirect_to edit_admin_user_path(@user.name), notice: "ユーザー情報を更新しました。"
    else
      # レシーバのユーザ名が不正値でupdateされるため正常値へ戻す
      @user.name = params[:name]
      render :edit
    end
  end
  
  def show
    # ユーザー情報
    @user = User.find_by(name: params[:name])
    
    # ユーザー投稿情報
    @notes = @user.notes
    @notes_index = @notes.page(params[:page])
    @favorite_notes = @user.favorite_notes
  end

  def search
    @results = @q.result.page(params[:page])
  end
  
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :is_deleted, :image)
  end
  
  def set_q
    @q = User.ransack(params[:q])
  end
  
end
