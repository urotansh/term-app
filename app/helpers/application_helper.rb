module ApplicationHelper
  # 改行(newline)を<br>へ変換
  def nl2br(str)
    raw(h(str).gsub(/\R/, "<br>"))
  end
  
end
