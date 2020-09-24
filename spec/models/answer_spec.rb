require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { FactoryBot.create(:question)}

  describe 'associtians' do
    it { should belong_to(:user) }
    it { should belong_to(:question) }
    it { should have_many(:links) }
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
      let(:question) { FactoryBot.create(:question) }
      let(:answer1) { FactoryBot.create(:answer, question: question) }
      let!(:answer2) { FactoryBot.create(:answer, question: question, best: true) }

      before { answer1.mark_as_best }

      it 'makes not best answer best' do
        expect(answer1.reload.best).to be true
      end

      it 'makes best answer not best' do
        expect(answer2.reload.best).to be false
      end
    end
  end

  it 'has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should accept_nested_attributes_for :links }
end
