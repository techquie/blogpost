# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :index, Story
    user ||= User.new

    case user.role
    when 'visitor'
      cannot :pending_approvals, Comment
      cannot :index, User
      can [:index, :show], Story
      can [:submit_comment], Comment
    when 'admin'
      can :manage, :all
    when 'super_admin'
      can :manage, :all
    else
      can :read, :all
      cannot :index, User
      cannot [:pending_approvals, :approve_comment, :submit_comment], Comment
    end
  end
end
