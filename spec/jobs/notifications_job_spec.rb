require 'rails_helper'

RSpec.describe NotificationsJob, type: :job do
  let(:question) { FactoryBot.create(:question) }
  it 'calls DailyDigestService#send_digest' do
    expect(NotificationsMailer).to receive(:notifications).with(question.user, question).and_call_original
    NotificationsJob.perform_now(question)
  end
end
