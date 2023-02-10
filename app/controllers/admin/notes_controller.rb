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
      @title = I18n.t("note.index")
      @user = User.find_by(name: params[:name])
      @notes = @user.notes
      @notes_pagination = @notes.page(params[:page])
    end
  end

  def show
    # 投稿情報
    @title = I18n.t("note.show")
    @note = Note.find(params[:id])
    
    # コメント機能
    @note_comment = NoteComment.new
    @note_comments = @note.note_comments.order(updated_at: :desc)
    @note_comments_pagination = @note_comments.page(params[:page]).per(5)
  end
  
  def destroy
    @note = Note.find(params[:id])
    # TODO:バリデーション
    @note.destroy
    
    # 遷移元URLを取得
    path = Rails.application.routes.recognize_path(request.referer)
    # ユーザーマイページからの削除の場合、ユーザーマイページへリダイレクト
    if path[:controller].split("/")[1] == "users"
      redirect_to admin_user_path(@note.user.name), notice: "投稿を削除しました。"
    # 検索画面からの削除の場合、検索一覧画面へリダイレクト
    elsif path[:controller].split("/")[1] == "notes"
      redirect_to session[:notes_show_previous_url], notice: "投稿を削除しました。"
    end
  end
  
end
