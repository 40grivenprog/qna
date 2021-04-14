# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:question) { FactoryBot.create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { FactoryBot.create(:access_token) }
      let!(:answers) { FactoryBot.create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at question_id user_id].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:question_id/answers/:id' do
    let(:access_token) { FactoryBot.create(:access_token) }
    let(:answer) { FactoryBot.create(:answer, :with_file) }
    let(:answer_response) { json['answer'] }
    let!(:link) { FactoryBot.create(:link, linkable: answer) }
    let!(:comment) { FactoryBot.create(:comment, commentable: answer) }
    let(:file_response) { answer_response['files'].first }
    let(:link_response) { answer_response['links'].first }
    let(:comment_response) { answer_response['comments'].first }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields' do
        %w[id body created_at updated_at question_id user_id].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'returns url for attached files' do
        %w[url].each do |attr|
          expect(file_response[attr]).to eq rails_blob_url(answer.files.first, only_path: true)
        end
      end

      it 'returns url for attached links' do
        %w[url].each do |attr|
          expect(link_response[attr]).to eq link.send(attr).as_json
        end
      end

      it 'returns all public fields for answer comment' do
        %w[id commentable_type commentable_id user_id body created_at updated_at].each do |attr|
          expect(comment_response[attr]).to eq comment.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /api/v1/question/:question_id/answers' do
    let(:user) { FactoryBot.create(:user) }
    let(:access_token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
    let(:method) { :post }
    let(:question) { FactoryBot.create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:answer_valid_params) do
      {
        body: 'Answer body'
      }
    end
    let(:answer_invalid_params) do
      {
        body: ''
      }
    end

    context 'with valid params' do
      it 'creates new user\'s answer' do
        expect { do_request(method, api_path, params: { access_token: access_token.token, answer: answer_valid_params }, headers: headers) }.to change(user.answers, :count).by(1)
      end
    end

    context 'invalid params' do
      it 'does not create new user\'s answer' do
        expect { do_request(method, api_path, params: { access_token: access_token.token, answer: answer_invalid_params }, headers: headers) }.to_not change(user.answers, :count)
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:author) { FactoryBot.create(:user) }
    let(:another_user) { FactoryBot.create(:user) }
    let(:author_access_token) { FactoryBot.create(:access_token, resource_owner_id: author.id) }
    let(:another_user_access_token) { FactoryBot.create(:access_token, resource_owner_id: another_user.id) }
    let(:method) { :patch }
    let!(:answer) { FactoryBot.create(:answer, user: author) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:answer_valid_params) do
      {
        body: 'Answer update test',
      }
    end
    let(:answer_invalid_params) do
      {
        body: '',
      }
    end
    context 'by author' do
      context 'with valid params' do
        before { do_request(method, api_path, params: { access_token: author_access_token.token, answer: answer_valid_params }, headers: headers) }
        it 'updates answer' do
          answer.reload
          expect(answer.body).to eq answer_valid_params[:body]
        end
      end

      context 'with invalid params' do
        before { do_request(method, api_path, params: { access_token: author_access_token.token, answer: answer_invalid_params }, headers: headers) }
        it 'not updates answer' do
          answer.reload
          expect(answer.body).to_not eq answer_valid_params[:body]
        end
      end
     end

    context 'by another user' do
      before { do_request(method, api_path, params: { access_token: another_user_access_token.token, question: answer_valid_params }, headers: headers) }
      it 'retunrns forbidden status' do
       expect(response.status).to eq 403
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:author) { FactoryBot.create(:user) }
    let(:another_user) { FactoryBot.create(:user) }
    let(:author_access_token) { FactoryBot.create(:access_token, resource_owner_id: author.id) }
    let(:another_user_access_token) { FactoryBot.create(:access_token, resource_owner_id: another_user.id) }
    let(:method) { :delete }
    let!(:answer) { FactoryBot.create(:answer, user: author) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    context 'author' do
      it 'removes answer' do
        expect { do_request(method, api_path, params: { access_token: author_access_token.token}, headers: headers) }.to change(author.answers, :count).by(-1)
      end
    end

    context 'another user' do
      it 'not removes answer' do
        expect { do_request(method, api_path, params: { access_token: another_user_access_token.token}, headers: headers) }.to_not change(author.answers, :count)
      end

      it 'retunrns forbidden status' do
       do_request(method, api_path, params: { access_token: another_user_access_token.token}, headers: headers)
       expect(response.status).to eq 403
      end
    end
  end
end
