class Public::NotesController < ApplicationController
  before_action :authenticate_user!, unless: :admin_signed_in?
  before_action :is_matching_login_user, only: [:edit, :update]
  
  def new
    @title = I18n.t("note.new")
    @note = Note.new
  end
  
  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id
    
    # タグが空白の場合
    if params[:note][:tag].empty?
      # 自然言語処理を行うプレーンテキスト情報を変数へ格納
      plain_text = @note.title + ',' + @note.content
      # プレーンテキストからコードブロックを除外
      plain_text.gsub!(/```.*```/m, "")
      # 重要度の高いエンティティを3つ抽出
      tag_list = Language.get_data(plain_text)
    # タグが空白ではない場合
    else
      tag_list = params[:note][:tag].split(',')
    end
      
    # TODO:バリデーション
    @note.save
    @note.save_tags(tag_list)
    redirect_to user_path(current_user.name), notice: I18n.t("note.notice.create")
  end

  def index
    if params[:note_search]
      @search_keyword = params[:keyword]
      @notes = Note.search(@search_keyword).page(params[:page])
      @notes_count = Note.search(@search_keyword).size
    elsif params[:tag_search]
      @search_keyword = params[:keyword]
      tags = Tag.search(@search_keyword)
      tag_ids = tags.pluck(:id)
      note_tags = NoteTag.where(tag_id: tag_ids)
      note_ids = note_tags.pluck(:note_id)
      @notes = Note.find(note_ids)
      @notes_count = @notes.size
      @notes = Kaminari.paginate_array(@notes).page(params[:page])
    else
      # TODO:DRY
      if params[:favorite]
        @title = I18n.t("favorite.index")
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
  end

  def show
    # 投稿情報
    @title = I18n.t("note.show")
    @note = Note.find(params[:id])
    
    # コメント機能
    @note_comment = NoteComment.new
    @note_comments = @note.note_comments.order(updated_at: :desc)
    @note_comments_pagination = @note_comments.page(params[:page]).per(5)

    # 遷移元URL(検索画面 or ユーザーマイページ)をセッションに保存
    session[:notes_show_previous_url] = request.referer
  end

  def edit
    @title = I18n.t("note.edit")
    @note = current_user.notes.find(params[:id])
  end
  
  def update
    @note = current_user.notes.find(params[:id])
    # TODO:バリデーション
    @note.update(note_params)
    
    # 遷移元URLを取得
    path = Rails.application.routes.recognize_path(request.referer)
    # ユーザーマイページからの更新の場合、ユーザーマイページへリダイレクト
    # TODO: 投稿一覧（サイドメニュー）へのタイトル更新反映、投稿詳細画面表示（非同期）
    if path[:controller].split("/")[1] == "users"
      redirect_to user_path(current_user.name), notice: I18n.t("note.notice.update")
    # 検索画面からの更新の場合、投稿詳細画面へリダイレクト
    elsif path[:controller].split("/")[1] == "notes"
      redirect_to note_path(@note), notice: I18n.t("note.notice.update")
    end
  end
  
  def destroy
    @note = current_user.notes.find(params[:id])
    # TODO:バリデーション
    @note.destroy
        
    # 遷移元URLを取得
    path = Rails.application.routes.recognize_path(request.referer)
    # ユーザーマイページからの削除の場合、ユーザーマイページへリダイレクト
    if path[:controller].split("/")[1] == "users"
      redirect_to user_path(current_user.name), notice: I18n.t("note.notice.destroy")
    # 検索画面からの削除の場合、検索一覧画面へリダイレクト
    elsif path[:controller].split("/")[1] == "notes"
      redirect_to session[:notes_show_previous_url], notice: I18n.t("note.notice.destroy")
    end
  end
  
  private
  
  def note_params
    params.require(:note).permit(:title, :content)
  end
   
  def is_matching_login_user
    user_id = Note.find(params[:id]).user.id.to_i
    login_user_id = current_user.id
    if(user_id != login_user_id)
      redirect_to user_path(current_user.name)
    end
  end
  
end
