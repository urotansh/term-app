class Admin::NoteCommentsController < ApplicationController
  def destroy
    @note_comment = NoteComment.find(params[:id])
    if @note_comment.destroy
      # *.js.erbで参照するインスタンス
      @note = Note.find(params[:note_id])
      @note_comments = @note.note_comments.order(updated_at: :desc)
      # where/findなどを使用するとArrayオブジェクトになるため、Kaminariオブジェクトを呼び出す
      @note_comments_pagination = Kaminari.paginate_array(@note_comments).page(params[:page]).per(5)
      render "destroy"
    else
      render "error"
    end
  end
end
