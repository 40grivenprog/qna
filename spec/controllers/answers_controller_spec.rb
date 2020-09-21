require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe 'POST #mark_as_best' do
    let(:question) { FactoryBot.create(:question, user: user) }
    let(:answer) { FactoryBot.create(:answer, question: question)}

    context 'question author marks as best' do
      before { login(user) }

      it 'updates answer best field' do
        post :mark_as_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).to be true
      end
    end

    context 'not question author marks as best' do
      let(:user1){ FactoryBot.create(:user) }

      before { login(user1) }

      it 'not updates answer best field' do
        post :mark_as_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).to be false
      end
    end
  end

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
         expect { delete :destroy, params: { id: answer}, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy teplate' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not author removes answer' do
      let(:user1){ FactoryBot.create(:user) }

      before { login(user1) }

      it 'removes answer' do
         expect { delete :destroy, params: { id: answer }, format: :js}.not_to change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { FactoryBot.create(:question) }
    let!(:answer) { FactoryBot.create(:answer, question: question, user: user) }

    context 'author updates his answer' do
      before { login(user) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update template' do
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

        it 'renders update template' do
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
