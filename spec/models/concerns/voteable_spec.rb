require 'rails_helper'

shared_examples 'voteable' do

  describe 'associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe 'methods' do
    context 'vote_for_by method' do
      let(:author) { FactoryBot.create(:user) }
      let(:not_author) { FactoryBot.create(:user) }
      let(:record) { FactoryBot.create(described_class.name.underscore.to_sym, user: author) }

      it 'should add new vote if not author votes for not for his record' do
        record.vote_for_by(not_author)
        expect(record.votes.length).to be 1
        expect(record.votes.first.score).to be 1
      end

      it 'should not add new vote if author votes for his record' do
        record.vote_for_by(author)
        expect(record.votes.length).to be 0
      end

      it 'should not add 2 new votes if not author votes for twice' do
        2.times { record.vote_for_by(not_author) }
        expect(record.votes.length).to be 1
      end
    end

    context 'vote_against_by method' do
      let(:author) { FactoryBot.create(:user) }
      let(:not_author) { FactoryBot.create(:user) }
      let(:record) { FactoryBot.create(described_class.name.underscore.to_sym, user: author) }

      it 'should add new vote if not author votes against not  his record' do
        record.vote_against_by(not_author)
        expect(record.votes.length).to be 1
        expect(record.votes.first.score).to be -1
      end

      it 'should not add new vote if author votes against  his record' do
        record.vote_against_by(author)
        expect(record.votes.length).to be 0
      end

      it 'should not add 2 new votes if not author votes for twice' do
        2.times { record.vote_against_by(not_author) }
        expect(record.votes.length).to be 1
      end
    end

    context 'cancel_vote_by method' do
      let(:author) { FactoryBot.create(:user) }
      let(:not_author) { FactoryBot.create(:user) }
      let(:record) { FactoryBot.create(described_class.name.underscore.to_sym, user: author) }

      before { record.vote_for_by(not_author) }

      it 'should cancel vote' do
        record.cancel_vote_by(not_author)
        record.reload
        expect(record.votes.length).to be 0
      end
    end

    context 'result of vote_for_by and vote_against_by after it' do
      let(:author) { FactoryBot.create(:user) }
      let(:not_author) { FactoryBot.create(:user) }
      let(:record) { FactoryBot.create(described_class.name.underscore.to_sym, user: author) }

      it 'should return negative vote' do
        record.vote_for_by(not_author)
        record.votes.reload
        record.vote_against_by(not_author)
        record.votes.reload
        expect(record.votes.last.score).to be -1
      end
    end
  end

    context 'calculate_score method' do
      let(:record) { FactoryBot.create(described_class.name.underscore.to_sym) }
      let(:votes) { FactoryBot.create_list(:vote, 3, voteable: record)}

      it 'should calculate votes for record if record has votes' do
        votes
        expect(record.calculate_score).to eq(3)
      end

      it 'should return 0 if record have\'t got votes' do
        expect(record.calculate_score).to eq(0)
      end
    end
end
