# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can [:create, :make_comment], [Question, Answer]
    can [:vote_for, :vote_against, :cancel_vote], [Question, Answer] do |resource|
      resource.user_id != user.id
    end
    can :destroy, Link, linkable: { user_id: user.id }
    can [:update, :destroy], [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id
    can :mark_as_best, Answer, question: { user_id: user.id }
  end
end
