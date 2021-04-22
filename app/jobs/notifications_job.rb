class NotificationsJob < ApplicationJob
  queue_as :default

  def perform(question)
    question.subscriptions.find_each do |subscription|
      NotificationsMailer.notifications(subscription.user, question).deliver_now
    end
  end
end
