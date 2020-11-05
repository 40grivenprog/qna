require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'attacheable'
  it_behaves_like 'linkable'
  it_behaves_like 'voteable'
  it_behaves_like 'commentable'

  let(:question) { FactoryBot.create(:question)}

  describe 'associtians' do
    it { should belong_to(:user) }
    it { should belong_to(:question) }
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
    it { should validate_length_of(:body).is_at_least(5) }
  end

  describe 'scopes' do
    context 'sort_by_best' do
      let(:answers) { FactoryBot.create_list(:answer, 2)}
      let(:best_answer) { FactoryBot.create(:answer, best: true) }

      it 'without best answer' do
        expect(Answer.sort_by_best).to  eq(answers)
      end

      it 'with best answer' do
        expect(Answer.sort_by_best).to  eq(answers.unshift(best_answer))
      end
    end

    context 'best answer scope' do
      let!(:answers) { FactoryBot.create_list(:answer, 2)}
      let(:best_answer) { FactoryBot.create(:answer, best: true) }

      it 'returns best answer' do
        expect(Answer.best_answer).to eq([best_answer])
      end
    end
  end

  describe 'methods' do
    context 'mark_as_best method' do
      let(:user) { FactoryBot.create(:user) }
      let(:question) { FactoryBot.create(:question) }
      let(:answer1) { FactoryBot.create(:answer, question: question, user: user) }
      let!(:answer2) { FactoryBot.create(:answer, question: question, best: true) }
      let!(:badge) { FactoryBot.create(:badge, question: question)}

      before { answer1.mark_as_best }

      it 'makes not best answer best' do
        expect(answer1.reload.best).to be true
      end

      it 'makes best answer not best' do
        expect(answer2.reload.best).to be false
      end

      it 'give badge for a user with best answer' do
        expect(badge.reload.user).to eq(answer1.reload.user)
      end
    end
  end
end
