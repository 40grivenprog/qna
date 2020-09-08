require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET #index' do
    let(:questions){ FactoryBot.create_list(:question, 3) }

    before { get :index }
    before { login(user) }

    it 'returns an array of all questions' do
      expect(assigns(:questions)).to match_array questions
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { login(user) }

    let(:question){ FactoryBot.create(:question) }

    before { get :show, params: { id: question }}

    it 'it assigns requested question to @question variable' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
   before { login(user) }

   before { get :new }

   it 'it assigns new question to variable @question' do
     expect(assigns(:question)).to be_a_new Question
   end

   it 'renders new view' do
     expect(response).to render_template :new
   end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid params' do
      it 'creates new test' do
       expect { post :create, params: { question: FactoryBot.attributes_for(:question) }}.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: FactoryBot.attributes_for(:question) }
        expect(response).to redirect_to(assigns(:question))
      end
    end

    context 'with invalid params' do
      it 'doesn\'t create new test' do
       expect { post :create, params: { question: FactoryBot.attributes_for(:question, :invalid) }}.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: FactoryBot.attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end
end
