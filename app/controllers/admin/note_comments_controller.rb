class Admin::NoteCommentsController < ApplicationController
  def destroy
    @note_comment = NoteComment.find(params[:id])
    if @note_comment.destroy
      # *.js.erbで参照するインスタンス
      @note = Note.find(params[:note_id])
      render "destroy"
    else
      render "error"
    end
  end
end
