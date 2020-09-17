require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){ FactoryBot.create(:user) }
  let(:question){ FactoryBot.create(:question, user: user)}

  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'instance methods' do
    context 'User author_of? method' do
      let(:question1){ FactoryBot.create(:question)}

      it 'is an author' do
       expect(user).to be_author_of(question)
      end

      it 'is not an author' do
       expect(user).to_not be_author_of(question1)
      end
    end
  end
end
