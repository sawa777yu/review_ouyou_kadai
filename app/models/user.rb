class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
	has_many :favorites, dependent: :destroy
	has_many :book_comments, dependent: :destroy
	has_many :follower_of_user,class_name: "Relationship", foreign_key:"followed_id", dependent: :destroy
	has_many :followers, through: :follower_of_user, source: :follower
	has_many :followed_of_user,class_name: "Relationship", foreign_key:"follower_id", dependent: :destroy
	has_many :followings, through: :followed_of_user, source: :followed

  def follow(user_id)
    followed_of_user.create(followed_id: user_id)
  end

  def unfollow(user_id)
    followed_of_user.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  attachment :profile_image, destroy: false

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
end
