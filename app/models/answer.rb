class Answer < ApplicationRecord
  include Linkable
  include Attacheable
  include Voteable
  include Commentable

  belongs_to :user
  belongs_to :question

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
    question = self.question
    question.subscriptions.find_each do |subscription|
      NotificationsMailer.notifications(subscription.user, question).deliver_later
    end
  end
end
