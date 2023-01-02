class Note < ApplicationRecord
  
  belongs_to :user
  has_many :note_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :note_tags, dependent: :destroy
  has_many :tags, through: :note_tags
  
  scope :search, -> (name) { where('title LIKE ?', "%#{name}%") }
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def save_tags(savenote_tags)
    # 現在のユーザーの持っているskillを引っ張ってきている
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 今noteが持っているタグと今回保存されたものの差をすでにあるタグとする。古いタグは消す。
    old_tags = current_tags - savenote_tags
    # 今回保存されたものと現在の差を新しいタグとする。新しいタグは保存
    new_tags = savenote_tags - current_tags
		
    # Destroy old taggings:
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name:old_name)
    end
		
    # Create new taggings:
    new_tags.each do |new_name|
      note_tag = Tag.find_or_create_by(name:new_name)
      # 配列に保存
      self.tags << note_tag
    end
  end
  
end
