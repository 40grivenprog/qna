require 'rails_helper'
require 'pry'

RSpec.describe AnswersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe 'POST #create' do
    let(:question) { FactoryBot.create(:question) }

    before { login(user) }

    context 'with valid params' do
      it 'creates new answer for question' do
       expect { post :create, params: { question_id: question, answer: FactoryBot.attributes_for(:answer), format: :js }}.to change(question.answers, :count).by(1)
      end

      it 'creates new user\'s answer' do
       expect { post :create, params: { question_id: question, answer: FactoryBot.attributes_for(:answer), format: :js }}.to change(user.answers, :count).by(1)
      end

      it 'redirects to questions#show view' do
        post :create, params: { question_id: question, answer: FactoryBot.attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid params' do
      it 'doesn\'t create new answer' do
       expect { post :create, params: { question_id: question, answer: FactoryBot.attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: FactoryBot.attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question){ FactoryBot.create(:question, user: user) }
    let!(:answer){ FactoryBot.create(:answer, question: question, user: user) }

    context 'author removes answer' do
      before { login(user) }

      it 'removes answer' do
         expect { delete :destroy, params: { id: answer }}.to change(Answer, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to(question_path(answer.question))
      end
    end

    context 'not author removes answer' do
      let(:user1){ FactoryBot.create(:user) }

      before { login(user1) }

      it 'removes answer' do
         expect { delete :destroy, params: { id: answer }}.not_to change(Answer, :count)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to(question_path(answer.question))
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let(:question) { FactoryBot.create(:question) }
    let!(:answer) { FactoryBot.create(:answer, question: question, user: user) }

    context 'author updates his answer' do
      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: FactoryBot.attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: FactoryBot.attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'not author updates answer' do
      let(:user1){ FactoryBot.create(:user) }

      before { login(user1)}

      it 'does not change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end
end
