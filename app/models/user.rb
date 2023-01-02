class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :image
  
  has_many :notes, dependent: :destroy
  has_many :note_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_notes, through: :favorites, source: :note

  validates :name,
    uniqueness: true,
    length: { minimum: 1, maximum: 20 },
    format: { with: /\A[a-zA-Z0-9]+\z/ }
      
  validates :name, user_name_reserved: true
  
  # ensure user is active
  def active_for_authentication?
    super && !is_deleted
  end

  # provide a custom message for a deleted user
  def inactive_message
    !is_deleted ? super : :deleted_user
  end
  
  # ゲストユーザ情報取得(存在しない場合、既定値で作成)
  def self.guest
    find_or_create_by!(name: "guestuser", email: "guest@guest.com") do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end
  
  # ユーザ画像取得
  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/default-image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end
  
end
