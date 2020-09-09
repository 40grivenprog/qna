require 'rails_helper'
require 'pry'

RSpec.describe AnswersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe 'POST #create' do
    let(:question) { FactoryBot.create(:question) }

    before { login(user) }

    context 'with valid params' do
      it 'creates new answer' do
       expect { post :create, params: { question_id: question, answer: FactoryBot.attributes_for(:answer) }}.to change(question.answers, :count).by(1)
      end

      it 'redirects to questions#show view' do
        post :create, params: { question_id: question, answer: FactoryBot.attributes_for(:answer) }
        expect(response).to redirect_to question_path question
      end
    end

    context 'with invalid params' do
      it 'doesn\'t create new answer' do
       expect { post :create, params: { question_id: question, answer: FactoryBot.attributes_for(:answer, :invalid) }}.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: FactoryBot.attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
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
        expect(response).to redirect_to question_path answer.question
      end
    end

    context 'not author removes answer' do
      let(:user1){ FactoryBot.create(:user) }

      before { login(user1) }

      it 'removes answer' do
         expect { delete :destroy, params: { id: answer }}.to change(Answer, :count).by(0)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path answer.question
      end
    end
  end
end
