require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:question) { FactoryBot.create(:question, :with_file, user: user) }
  let!(:attached_file) { question.files.first }
  let(:user2) { FactoryBot.create(:user) }

  subject { delete :destroy, params: { id: attached_file }, format: :js }

  describe 'DELETE #destroy' do
    context 'author of question' do
      before { sign_in user }

      it 'should delete attached file' do
        expect { subject }.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'should render destroy template' do
        subject
        expect(response).to render_template :destroy
      end
    end

    context 'not author of question' do
      before { sign_in user2}

      it 'should not delete attached_file' do
        expect { subject }.not_to change(ActiveStorage::Attachment, :count)
      end
    end

    context 'not authenticated user' do
      it 'should not delete attached_file' do
        expect { subject }.not_to change(ActiveStorage::Attachment, :count)
      end
    end
  end
end
