require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET #index' do
    let(:questions){ FactoryBot.create_list(:question, 3) }

    before { login(user) }
    before { get :index }

    it 'returns an array of all questions' do
      expect(assigns(:questions)).to match_array questions
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question){ FactoryBot.create(:question) }

    before { login(user) }
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

   it 'it generates new link for a @question' do
     expect(assigns(:question).links.first).to be_a_new Link
   end

   it 'renders new view' do
     expect(response).to render_template :new
   end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid params' do
      it 'creates new user\'s question' do
       expect { post :create, params: { question: FactoryBot.attributes_for(:question) }}.to change(user.questions, :count).by(1)
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

  describe 'DELETE #destroy' do
    let!(:question){ FactoryBot.create(:question, user: user) }

    context 'author removes question' do
      before { login(user) }

      it 'removes question' do
         expect { delete :destroy, params: { id: question }}.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'not author removes question' do
      let(:user1){ FactoryBot.create(:user) }

      before { login(user1) }

      it 'removes question' do
         expect { delete :destroy, params: { id: question }}.not_to change(Question, :count)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { FactoryBot.create(:question, user: user) }

    context 'author updates his question' do
      before { login(user) }

      context 'with valid attributes' do
        it 'changes question attributes' do
          patch :update, params: { id: question, question: { body: 'new question body' } }, format: :js
          question.reload
          expect(question.body).to eq 'new question body'
        end

        it 'renders update template' do
          patch :update, params: { id: question, question: { body: 'new question body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change question attributes' do
          expect do
            patch :update, params: { id: question, question: FactoryBot.attributes_for(:question, :invalid) }, format: :js
          end.to_not change(question, :body)
        end

        it 'renders update template' do
          patch :update, params: { id: question, question: FactoryBot.attributes_for(:question, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'not author updates question' do
      let(:user1){ FactoryBot.create(:user) }

      before { login(user1)}

      it 'does not change question attributes' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        question.reload
        expect(question.body).to_not eq 'new body'
      end
    end
  end
end
