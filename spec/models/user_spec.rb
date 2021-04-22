require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){ FactoryBot.create(:user) }
  let(:question){ FactoryBot.create(:question, user: user)}

  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
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
      let(:another_user_question){ FactoryBot.create(:question)}

      it 'returns true if user is an author' do
       expect(user).to be_author_of(question)
      end

      it 'returns false if user is an author' do
       expect(user).to_not be_author_of(another_user_question)
      end
    end

    context 'User has_subscription? method' do
      let(:another_user_question) { FactoryBot.create(:question) }

      it 'returns true if user has subscription to a question' do
       expect(user.find_subscription(question)).to be_truthy
      end

      it 'returns false if user has not got subscription to a question' do
       expect(user.find_subscription(another_user_question)).to be_falsey
      end
    end
  end
end
