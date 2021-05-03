class Answer < ApplicationRecord
  include Linkable
  include Attacheable
  include Voteable
  include Commentable

  belongs_to :user
  belongs_to :question, touch: true

  validates :body, presence: true, length: { minimum: 5 }

  scope :sort_by_best, -> { order(best: :desc)}
  scope :best_answer, -> { where(best: true) }

  after_create :send_notifications

  def mark_as_best
    transaction do
      question.best_answer&.update!(best: false)
      question.badge&.update!(user_id: user_id)
      update!(best: true)
    end
  end

  private

  def send_notifications
    NotificationsJob.perform_later(question)
  end
end
