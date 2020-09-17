require 'rails_helper'

RSpec.describe Question, type: :model do

  describe 'associations' do
    it { should belong_to(:user) }
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
  end
end
