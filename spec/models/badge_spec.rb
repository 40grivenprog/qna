require 'rails_helper'

RSpec.describe Badge, type: :model do

  describe 'associations' do
    it { should belong_to(:user).optional }
    it { should belong_to(:question) }
  end

  it 'has one attached file' do
    expect(Badge.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
