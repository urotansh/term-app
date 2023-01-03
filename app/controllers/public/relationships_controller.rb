class Public::RelationshipsController < ApplicationController
  def create
    @user = User.find_by(name: params[:user_name])
    current_user.follow(@user)
  end

  def destroy
    @user = User.find_by(name: params[:user_name])
    current_user.unfollow(@user)
  end
end
