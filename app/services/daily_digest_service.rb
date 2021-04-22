class DailyDigestService
  def send_digest
    User.find_each do |user|
      DailyDigestMailer.digest(user).deliver_now
    end
  end
end
