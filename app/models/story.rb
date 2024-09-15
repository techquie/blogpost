class Story < ApplicationRecord
  ###### ASSOCIATIONS ######
  belongs_to :user
  has_many :comments

  ###### VALIDATIONS ######
  validates :content, :user_id, presence: true
  validates :content, length: { maximum: 1000, minimum: 20 }

  ###### SCOPES ######
  default_scope { where(published: true) }

end
