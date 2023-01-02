class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    favorite = Favorite.new(user_id: current_user.id, note_id: params[:note_id])
    favorite.save
    
    # *.js.erbで参照するインスタンス
    @note = Note.find(params[:note_id])
  end

  def destroy
    favorite = Favorite.find_by(user_id: current_user.id, note_id: params[:note_id])
    favorite.destroy
    
    # *.js.erbで参照するインスタンス
    @note = Note.find(params[:note_id])
  end
end
