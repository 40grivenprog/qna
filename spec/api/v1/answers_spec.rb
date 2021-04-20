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
      let!(:records) { FactoryBot.create_list(:answer, 2, question: question) }
      let(:record) { records.first }
      let(:record_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at question_id user_id].each do |attr|
          expect(record_response[attr]).to eq record.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:question_id/answers/:id' do
    let(:access_token) { FactoryBot.create(:access_token) }
    let(:record) { FactoryBot.create(:answer, :with_file) }
    let(:record_response) { json['answer'] }
    let!(:link) { FactoryBot.create(:link, linkable: record) }
    let!(:comment) { FactoryBot.create(:comment, commentable: record) }
    let(:file_response) { record_response['files'].first }
    let(:link_response) { record_response['links'].first }
    let(:comment_response) { record_response['comments'].first }

    let(:api_path) { "/api/v1/answers/#{record.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields' do
        %w[id body created_at updated_at question_id user_id].each do |attr|
          expect(record_response[attr]).to eq record.send(attr).as_json
        end
      end

      it_behaves_like 'API FileReadeable'
      it_behaves_like 'API CommentReadeable'
      it_behaves_like 'API LinkReadeable'
    end
  end

  describe 'POST /api/v1/question/:question_id/answers' do
    let(:user) { FactoryBot.create(:user) }
    let(:access_token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
    let(:method) { :post }
    let(:question) { FactoryBot.create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:record_valid_params) do
      {
        body: 'Answer body'
      }
    end
    let(:record_invalid_params) do
      {
        body: ''
      }
    end

    context 'with valid params' do
      it 'creates new user\'s answer' do
        expect { do_request(method, api_path, params: { access_token: access_token.token, answer: record_valid_params }, headers: headers) }.to change(user.answers, :count).by(1)
      end
    end

    context 'invalid params' do
      it 'does not create new user\'s answer' do
        expect { do_request(method, api_path, params: { access_token: access_token.token, answer: record_invalid_params }, headers: headers) }.to_not change(user.answers, :count)
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:author) { FactoryBot.create(:user) }
    let(:another_user) { FactoryBot.create(:user) }
    let(:author_access_token) { FactoryBot.create(:access_token, resource_owner_id: author.id) }
    let(:another_user_access_token) { FactoryBot.create(:access_token, resource_owner_id: another_user.id) }
    let(:method) { :patch }
    let!(:record) { FactoryBot.create(:answer, user: author) }
    let(:api_path) { "/api/v1/answers/#{record.id}" }
    let(:record_valid_params) do
      {
        body: 'Answer update test',
      }
    end
    let(:record_invalid_params) do
      {
        body: '',
      }
    end
    context 'by author' do
      context 'with valid params' do
        before { do_request(method, api_path, params: { access_token: author_access_token.token, answer: record_valid_params }, headers: headers) }
        it 'updates answer' do
          record.reload
          expect(record.body).to eq record_valid_params[:body]
        end
      end

      context 'with invalid params' do
        before { do_request(method, api_path, params: { access_token: author_access_token.token, answer: record_invalid_params }, headers: headers) }
        it 'not updates answer' do
          record.reload
          expect(record.body).to_not eq record_valid_params[:body]
        end
      end
     end

    context 'by another user' do
      before { do_request(method, api_path, params: { access_token: another_user_access_token.token, question: record_valid_params }, headers: headers) }
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
    let!(:record) { FactoryBot.create(:answer, user: author) }
    let(:api_path) { "/api/v1/answers/#{record.id}" }

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
