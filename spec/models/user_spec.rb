require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){ FactoryBot.create(:user) }
  let(:question){ FactoryBot.create(:question, user: user)}

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'is expected that user author_of? method works correct' do
   expect(user.author_of?(question)).to be true
  end
end
