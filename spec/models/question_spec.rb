require 'rails_helper'

RSpec.describe Question, type: :model do

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_one(:badge).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_length_of(:title).is_at_least(5) }
    it { should validate_presence_of :body }
    it { should validate_length_of(:body).is_at_least(10) }
  end

  describe 'methods' do
    context 'best_answer method' do
      let(:question) { FactoryBot.create(:question) }
      let!(:answers) { FactoryBot.create_list(:answer, 2, question: question)}
      let!(:best_answer) { FactoryBot.create(:answer, best: true, question: question)}

      it 'returns best answer for question' do
        expect(question.best_answer).to eq(best_answer)
      end
    end

    context 'calculate_score method' do
      let(:question) { FactoryBot.create(:question) }
      let(:votes) { FactoryBot.create_list(:vote, 3, voteable: question)}

      it 'should calculate votes for question if question has votes' do
        votes
        expect(question.calculate_score).to eq(3)
      end

      it 'should return 0 if question have\'t got votes' do
        expect(question.calculate_score).to eq(0)
      end
    end

    context 'vote_for_by method' do
      let(:author) { FactoryBot.create(:user) }
      let(:not_author) { FactoryBot.create(:user) }
      let(:question) { FactoryBot.create(:question, user: author) }

      it 'should add new vote if not author votes for not for his question' do
        question.vote_for_by(not_author)
        expect(question.votes.length).to be 1
        expect(question.votes.first.score).to be 1
      end

      it 'should not add new vote if author votes for his question' do
        question.vote_for_by(author)
        expect(question.votes.length).to be 0
      end

      it 'should not add 2 new votes if not author votes for twice' do
        2.times { question.vote_for_by(not_author) }
        expect(question.votes.length).to be 1
      end
    end

    context 'vote_against_by method' do
      let(:author) { FactoryBot.create(:user) }
      let(:not_author) { FactoryBot.create(:user) }
      let(:question) { FactoryBot.create(:question, user: author) }

      it 'should add new vote if not author votes against not  his question' do
        question.vote_against_by(not_author)
        expect(question.votes.length).to be 1
        expect(question.votes.first.score).to be -1
      end

      it 'should not add new vote if author votes against  his question' do
        question.vote_against_by(author)
        expect(question.votes.length).to be 0
      end

      it 'should not add 2 new votes if not author votes for twice' do
        2.times { question.vote_against_by(not_author) }
        expect(question.votes.length).to be 1
      end
    end

    context 'cancel_vote_by method' do
      let(:author) { FactoryBot.create(:user) }
      let(:not_author) { FactoryBot.create(:user) }
      let(:question) { FactoryBot.create(:question, user: author) }

      before { question.vote_for_by(not_author) }

      it 'should cancel vote' do
        question.cancel_vote_by(not_author)
        question.reload
        expect(question.votes.length).to be 0
      end
    end
  end



  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should accept_nested_attributes_for :badge }
  it { should accept_nested_attributes_for :links }
end
