class Question < ApplicationRecord
  include Linkable
  include Attacheable

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy, as: :voteable
  has_one :badge, dependent: :destroy

  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 10 }

  accepts_nested_attributes_for :badge, reject_if: :all_blank

  def best_answer
    answers.best_answer.first
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
    if votes.empty?
      0
    else
      votes.pluck(:score).sum
    end
  end
end
