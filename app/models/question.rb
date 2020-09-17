class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 10 }

  def best_answer
    answers.best_answer.first
  end
end
