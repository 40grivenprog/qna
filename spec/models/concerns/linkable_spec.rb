require 'rails_helper'

shared_examples 'linkable' do

  describe 'associations' do
    it { should have_many(:links).dependent(:destroy) }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for :links }
  end
end
