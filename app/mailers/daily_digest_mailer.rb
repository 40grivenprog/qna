class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    @new_questions = Question.where(created_at: (Time.now.midnight - 1.day)..Time.now)
    mail to: user.email
  end
end
