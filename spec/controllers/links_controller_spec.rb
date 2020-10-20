require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:question) { FactoryBot.create(:question, user: user) }
  let!(:link) { FactoryBot.create(:link, linkable: question) }
  let(:user2) { FactoryBot.create(:user) }

  subject { delete :destroy, params: { id: link }, format: :js }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      context 'user author of a question' do
        before { login(user) }

        it 'destroys link for a question' do
          expect { subject }.to change(Link, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: link }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'user not author of a question' do
        before { login(user2) }

        it 'destroys link for a question' do
          expect { subject }.to_not change(Link, :count)
        end
      end
    end
  end
end
