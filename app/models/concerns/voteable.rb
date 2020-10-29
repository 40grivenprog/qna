module Voteable
  extend ActiveSupport::Concern
  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def vote_for_by(user)
    return if user.author_of? self

    user_vote = votes.find_by(user: user)
    if user_vote
      user_vote.update(score: 1)
    else
      votes.create(user: user, score: 1)
    end
  end

  def vote_against_by(user)
    return if user.author_of? self

    user_vote = votes.find_by(user: user)
    if user_vote
      user_vote.update(score: -1)
    else
      votes.create(user: user, score: -1)
    end
  end

  def cancel_vote_by(user)
    user_vote = votes.find_by(user: user)

    return unless user_vote

    user_vote.destroy
  end

  def calculate_score
    votes.sum(:score) || 0
  end
end
