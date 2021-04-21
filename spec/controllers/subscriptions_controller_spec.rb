require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe 'POST #create' do
    before { login(user) }

    let(:question) { FactoryBot.create(:question) }

    subject { post :create, params: { question_id: question.id }, format: :js }

    it 'creates new subscription' do
      expect { subject }.to change(user.subscriptions, :count).by(1)
    end

    it 'renders create' do
      subject
      expect(response).to render_template :create
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let(:question) { FactoryBot.create(:question, user: user) }

    before { delete :destroy, params: { id: question.subscriptions.first.id }, format: :js }

    it 'destroys subscription' do
      expect(user.subscriptions.count).to be 0
    end

    it 'renders destroy' do
      expect(response).to render_template :destroy
    end
  end
end
