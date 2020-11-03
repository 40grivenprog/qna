require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_behaves_like 'attacheable'

  describe 'associations' do
    it { should belong_to(:commentable) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end
end
