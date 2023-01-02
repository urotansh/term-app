class Favorite < ApplicationRecord
  
  belongs_to :user
  belongs_to :note
  
  # 1ユーザは1投稿に対して1件だけいいね可能
  validates_uniqueness_of :note_id, scope: :user_id
  
end
