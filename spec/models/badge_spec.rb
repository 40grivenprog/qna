require 'rails_helper'

RSpec.describe Badge, type: :model do

  describe 'associations' do
    it { should belong_to(:user).optional }
    it { should belong_to(:question) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :image }
  end

  it 'has one attached file' do
    expect(Badge.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  describe 'image format validation' do
    let(:badge) { FactoryBot.create(:badge) }

    it { expect(badge).to be_valid }
    it { expect(badge.image.attach fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")).to be false }
  end
end
