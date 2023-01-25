class Admin::NotesController < ApplicationController
  def index
    # TODO:DRY
    if params[:favorite]
      @title = "いいね一覧"
      @user = User.find_by(name: params[:name])
      @note_ids = @user.favorites.pluck(:note_id)
      @notes = Note.find(@note_ids)
      # where/findなどを使用するとArrayオブジェクトになるため、Kaminariオブジェクトを呼び出す
      @notes_pagination = Kaminari.paginate_array(@notes).page(params[:page])
    else
      @title = "投稿一覧"
      @user = User.find_by(name: params[:name])
      @notes = @user.notes
      @notes_pagination = @notes.page(params[:page])
    end
  end

  def show
    # 投稿情報
    @note = Note.find(params[:id])
    
    # コメント機能
    @note_comment = NoteComment.new
  end
  
  def destroy
    @note = Note.find(params[:id])
    # TODO:バリデーション
    @note.destroy
    redirect_to admin_user_path(@note.user.name), notice: "投稿を削除しました。"
  end
  
end
