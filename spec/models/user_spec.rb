require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){ FactoryBot.create(:user) }
  let(:question){ FactoryBot.create(:question, user: user)}

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'User author_of? method' do
    let(:question1){ FactoryBot.create(:question)}

    it 'if user is an author' do
     expect(user).to be_author_of(question)
    end

    it 'if user is not an author' do
     expect(user).to_not be_author_of(question1)
    end
  end
end
