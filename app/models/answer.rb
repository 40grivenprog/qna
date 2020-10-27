class Answer < ApplicationRecord
  include Linkable
  include Attacheable

  belongs_to :user
  belongs_to :question
  has_many :votes, dependent: :destroy, as: :voteable
  validates :body, presence: true, length: { minimum: 5 }

  scope :sort_by_best, -> { order(best: :desc)}
  scope :best_answer, -> { where(best: true) }

  def mark_as_best
    transaction do
      question.best_answer&.update!(best: false)
      question.badge&.update!(user_id: user_id)
      update!(best: true)
    end
  end
end
