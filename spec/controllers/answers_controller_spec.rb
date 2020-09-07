require 'rails_helper'
require 'pry'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #index' do
    let(:answers) { FactoryBot.create_list(:answer, 1) }

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

   before { get :show, params: { question_id: answer.question, id: answer}}

   it 'assigns necessary answer to @answer variable' do
    expect(assigns(:answer)).to eq answer
   end

   it 'renders show template' do
    expect(response).to render_template :show
   end
  end

  describe 'GET #new' do
   let(:question) { FactoryBot.create(:question) }

   before { get :new, params: { question_id: question }}

   it 'it assigns new answer to variable @answer' do
     expect(assigns(:answer)).to be_a_new Answer
   end

   it 'renders new view' do
     expect(response).to render_template :new
   end
  end

  describe 'POST #create' do
    let(:question) { FactoryBot.create(:question) }

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
        expect(response).to render_template :new
      end
    end
  end
end
