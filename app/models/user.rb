class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { super_admin: 0, admin: 1, visitor: 2 }

  ###### VALIDATIONS ######
  validates :email, :name, :role, presence: true
  validates :name, length: { maximum: 20, minimum: 5 }

  ###### ASSOCIATIONS ######
  has_one :story, dependent: :destroy
  has_many :comments_by_user, class_name: 'Comment', foreign_key: 'comment_by'

  ###### CALLBACKS ######

  ###### UTILITY METHODS ######

  def admin?
    role == User.roles.keys[1]
  end

  def super_admin?
    role == User.roles.keys[0]
  end

  def visitor?
    role == User.roles.keys[2]
  end

  def active_for_authentication?
    super && active?
  end
end
