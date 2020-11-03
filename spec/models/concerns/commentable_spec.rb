require 'rails_helper'

shared_examples 'commentable' do

  describe 'associations' do
    it { should have_many(:comments).dependent(:destroy) }
  end
end
