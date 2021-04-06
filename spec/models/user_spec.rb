require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){ FactoryBot.create(:user) }
  let(:question){ FactoryBot.create(:question, user: user)}

  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:badges) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'instance methods' do
    context 'User author_of? method' do
      let(:question1){ FactoryBot.create(:question)}

      it 'returns true if user is an author' do
       expect(user).to be_author_of(question)
      end

      it 'returns false if user is an author' do
       expect(user).to_not be_author_of(question1)
      end
    end
  end
end
