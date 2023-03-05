class Public::NoteCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: [:create, :destroy, :index]
  
  def create
    @note_comment = NoteComment.new(note_comment_params)
    @note_comment.user_id = current_user.id
    @note_comment.note_id = params[:note_id]
    
    if @note_comment.save
      @note_comments = @note.note_comments.order(updated_at: :desc)
      @note_comments_pagination = @note_comments.page(params[:page]).per(5)
      render "create"
    else
      render "error"
    end
      
  end

  def destroy
    @note_comment = NoteComment.find(params[:id])
    if @note_comment.destroy
      @note_comments = @note.note_comments.order(updated_at: :desc)
      @note_comments_pagination = @note_comments.page(params[:page]).per(5)
      
      # ページャの更新判定（コメント削除時にページ数が減った場合、ページャを更新する）
      @update_pager_flg = update_pager?(@note_comments)
      
      render "destroy"
    else
      render "error"
    end
  end
  
  def index
    # コメント一覧
    @note_comments = @note.note_comments.order(updated_at: :desc)
    @note_comments_pagination = @note_comments.page(params[:page]).per(5)
  end
  
  private
  
  def set_note
    @note = Note.find(params[:note_id])
  end
  
  def note_comment_params
    params.require(:note_comment).permit(:comment)
  end
  
  def update_pager?(note_comments)
    # コメント件数が1ページへの最大表示件数で割り切れる場合、ページャを更新する
    # if note_comments.size % Kaminari.config.default_per_page == 0
    if note_comments.size % 5 == 0
      return true
    else
      return false
    end
  end
  
end
