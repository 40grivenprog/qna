class NotificationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.notifications.subject
  #
  def notifications(user, question)
    @question = question

    mail to: user.email
  end
end
