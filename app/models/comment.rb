class Comment < ApplicationRecord
  ###### VALIDATIONS ######
  validates :content, :comment_by, :story_id, presence: true
  validates :content, length: { maximum: 50, minimum: 5 }

  ###### ASSOCIATIONS ######
  belongs_to :story
  belongs_to :comment_by, class_name: 'User', foreign_key: 'comment_by'

  ###### CALLBACKS ######

  ###### SCOPE ######
  scope :approved_comments, -> { where(approved_by_admin: true, approved_by_sadmin: true) }
  scope :sadmin_pending_approvals, -> { where(approved_by_admin: true, approved_by_sadmin: false) }
  scope :admin_pending_approvals, -> { where(approved_by_admin: false, approved_by_sadmin: false) }

end
