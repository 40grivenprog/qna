class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, dependent: :destroy

  has_many_attached :files

  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 10 }

  def best_answer
    answers.best_answer.first
  end
end
