# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { FactoryBot.create(:access_token) }
      let!(:questions) { FactoryBot.create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:access_token) { FactoryBot.create(:access_token) }
    let(:question) { FactoryBot.create(:question, :with_file) }
    let(:question_response) { json['question'] }
    let!(:link) { FactoryBot.create(:link, linkable: question) }
    let!(:comment) { FactoryBot.create(:comment, commentable: question) }
    let(:file_response) { question_response['files'].first }
    let(:link_response) { question_response['links'].first }
    let(:comment_response) { question_response['comments'].first }

    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'returns url for attached files' do
        %w[url].each do |attr|
          expect(file_response[attr]).to eq rails_blob_url(question.files.first, only_path: true)
        end
      end

      it 'returns url for attached links' do
        %w[url].each do |attr|
          expect(link_response[attr]).to eq link.send(attr).as_json
        end
      end

      it 'returns all public fields for question comment' do
        %w[id commentable_type commentable_id user_id body created_at updated_at].each do |attr|
          expect(comment_response[attr]).to eq comment.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:user) { FactoryBot.create(:user) }
    let(:access_token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
    let(:method) { :post }
    let(:api_path) { '/api/v1/questions' }
    let(:question_valid_params) do
      {
        title: 'Question title',
        body: 'Question body'
      }
    end
    let(:question_invalid_params) do
      {
        title: '',
        body: 'Question body'
      }
    end

    context 'with valid params' do
      it 'creates new user\'s question' do
        expect { do_request(method, api_path, params: { access_token: access_token.token, question: question_valid_params }, headers: headers) }.to change(user.questions, :count).by(1)
      end
    end

    context 'invalid params' do
      it 'does not create new user\'s question' do
        expect { do_request(method, api_path, params: { access_token: access_token.token, question: question_invalid_params }, headers: headers) }.to_not change(user.questions, :count)
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:author) { FactoryBot.create(:user) }
    let(:another_user) { FactoryBot.create(:user) }
    let(:author_access_token) { FactoryBot.create(:access_token, resource_owner_id: author.id) }
    let(:another_user_access_token) { FactoryBot.create(:access_token, resource_owner_id: another_user.id) }
    let(:method) { :patch }
    let!(:question) { FactoryBot.create(:question, user: author) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:question_valid_params) do
      {
        title: 'Question update test',
      }
    end
    let(:question_invalid_params) do
      {
        title: '',
      }
    end
    context 'by author' do
      context 'with valid params' do
        before { do_request(method, api_path, params: { access_token: author_access_token.token, question: question_valid_params }, headers: headers) }
        it 'updates question' do
          question.reload
          expect(question.title).to eq question_valid_params[:title]
        end
      end

      context 'with invalid params' do
        before { do_request(method, api_path, params: { access_token: author_access_token.token, question: question_invalid_params }, headers: headers) }
        it 'not updates question' do
          question.reload
          expect(question.title).to_not eq question_valid_params[:title]
        end
      end
     end

    context 'by another user' do
      before { do_request(method, api_path, params: { access_token: another_user_access_token.token, question: question_invalid_params }, headers: headers) }
      it 'retunrns forbidden status' do
       expect(response.status).to eq 403
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:author) { FactoryBot.create(:user) }
    let(:another_user) { FactoryBot.create(:user) }
    let(:author_access_token) { FactoryBot.create(:access_token, resource_owner_id: author.id) }
    let(:another_user_access_token) { FactoryBot.create(:access_token, resource_owner_id: another_user.id) }
    let(:method) { :delete }
    let!(:question) { FactoryBot.create(:question, user: author) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    context 'author' do
      it 'removes question' do
        expect { do_request(method, api_path, params: { access_token: author_access_token.token}, headers: headers) }.to change(author.questions, :count).by(-1)
      end
    end

    context 'another user' do
      it 'not removes question' do
        expect { do_request(method, api_path, params: { access_token: another_user_access_token.token}, headers: headers) }.to_not change(author.questions, :count)
      end

      it 'retunrns forbidden status' do
       do_request(method, api_path, params: { access_token: another_user_access_token.token}, headers: headers)
       expect(response.status).to eq 403
      end
    end
  end
end
