class Public::NotesController < ApplicationController
  # before_action :authenticate_user!
  before_action :is_matching_login_user, only: [:edit, :update]
  
  def new
    @note = Note.new
  end
  
  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id
    tag_list = params[:note][:tag_name].split(',')
    
    # TODO:バリデーション
    @note.save
    @note.save_tags(tag_list)
    redirect_to user_path(current_user.name), notice: "新規投稿が成功しました。"
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
  end

  def show
    # 投稿情報
    @note = Note.find(params[:id])
    
    # コメント機能
    @note_comment = NoteComment.new
  end

  def edit
    @note = current_user.notes.find(params[:id])
  end
  
  def update
    @note = current_user.notes.find(params[:id])
    # TODO:バリデーション
    @note.update(note_params)
    redirect_to user_path(current_user.name), notice: "投稿内容を更新しました。"
  end
  
  def destroy
    @note = current_user.notes.find(params[:id])
    # TODO:バリデーション
    @note.destroy
    redirect_to user_path(current_user.name), notice: "投稿を削除しました。"
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
