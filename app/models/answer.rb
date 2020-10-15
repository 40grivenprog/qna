class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  validates :body, presence: true, length: { minimum: 5 }

  accepts_nested_attributes_for :links, reject_if: :all_blank

  scope :sort_by_best, -> { order(best: :desc)}
  scope :best_answer, -> { where(best: true) }

  def mark_as_best
    transaction do
      question.best_answer&.update!(best: false)
      question.badges&.first&.update!(user_id: user_id)
      update!(best: true)
    end
  end
end
