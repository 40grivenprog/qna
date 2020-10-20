require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url}
    it { should allow_value('https://foo.com').for(:url) }
    it { should_not allow_value('foo').for(:url) }
  end

  describe 'associations' do
    it { should belong_to(:linkable) }
  end

  describe 'methods' do
    let(:gist) { FactoryBot.create(:link, url: 'https://gist.github.com/40grivenprog/7a08f276fbab891486e43dbc9c169faf') }

    context 'is_gist? method' do
      let(:gist) { FactoryBot.create(:link, url: 'https://gist.github.com/40grivenprog/7a08f276fbab891486e43dbc9c169faf') }
      let(:not_gist) { FactoryBot.create(:link, url: 'https://yandex.by/') }

      it 'returns true if link is gist' do
        expect(gist.is_gist?).to be true
      end
      it 'returns false if link is not gist' do
        expect(not_gist.is_gist?).to be false
      end
    end

    context 'read_gist method' do
      it 'returns files of a gist' do
        expect(gist.read_gist).to be_a Sawyer::Resource
      end
    end
  end
end
