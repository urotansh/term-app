class Tag < ApplicationRecord
  
  has_many :note_tags, dependent: :destroy
  has_many :notes, through: :note_tags
  
  scope :search, -> (name) { where('name LIKE ?', "%#{name}%") }
  
end
