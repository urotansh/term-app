class Admin::NotesController < ApplicationController
  def index
    # TODO:DRY
    if params[:favorite]
      @user = User.find_by(name: params[:name])
      @note_ids = @user.favorites.pluck(:note_id)
      @notes = Note.find(@note_ids)
      # TODO:ページネーションのAjax化
      @notes_ajax = @notes
      # where/findなどを使用するとArrayオブジェクトになるため、Kaminariオブジェクトを呼び出す
      @notes = Kaminari.paginate_array(@notes).page(params[:page])
    else
      @user = User.find_by(name: params[:name])
      @notes = @user.notes.page(params[:page])
      # TODO:ページネーションのAjax化
      @notes_ajax = @user.notes
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
