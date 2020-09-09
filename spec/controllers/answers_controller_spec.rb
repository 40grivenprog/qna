require 'rails_helper'
require 'pry'

RSpec.describe AnswersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET #index' do
    let(:answers) { FactoryBot.create_list(:answer, 1) }

    before { login(user) }
    before { get :index, params: { question_id: answers.first.question } }

    it 'assigns list of all answers for the question to @answers' do
       expect(assigns(:answers)).to match_array answers
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
   let(:answer) { FactoryBot.create(:answer) }

   before { login(user) }
   before { get :show, params: { question_id: answer.question, id: answer}}

   it 'assigns necessary answer to @answer variable' do
    expect(assigns(:answer)).to eq answer
   end

   it 'renders show template' do
    expect(response).to render_template :show
   end
  end

  describe 'POST #create' do
    let(:question) { FactoryBot.create(:question) }

    before { login(user) }

    context 'with valid params' do
      it 'creates new answer' do
       expect { post :create, params: { question_id: question, answer: FactoryBot.attributes_for(:answer) }}.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: FactoryBot.attributes_for(:answer) }
        expect(response).to redirect_to(assigns(:answer))
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

    before { login(user) }

    it 'removes question' do
       expect { delete :destroy, params: { id: answer }}.to change(Answer, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to questions_path
    end
  end
end
