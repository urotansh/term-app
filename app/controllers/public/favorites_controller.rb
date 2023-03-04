class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: [:create, :destroy]
  
  def create
    favorite = Favorite.new(user_id: current_user.id, note_id: params[:note_id])
    favorite.save
  end

  def destroy
    favorite = Favorite.find_by(user_id: current_user.id, note_id: params[:note_id])
    favorite.destroy
  end
  
  private
  
  def set_note
    @note = Note.find(params[:note_id])
  end
  
end
