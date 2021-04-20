shared_examples 'voted' do |record_name|

    describe 'POST #vote_for' do
    let(:author) { FactoryBot.create(:user) }

    context 'votes not for his record' do
      before { login(user) }

      let(:record) { FactoryBot.create(record_name, user: author) }

      it 'add new vote for record' do
        post :vote_for, params: { id: record }, format: :json

        expect(record.votes.count).to be(1)
        expect(record.votes.last.score).to be(1)
      end

      it 'didn\'t add new vote for record if he vote twice' do
        2.times { post :vote_for, params: { id: record }, format: :json }
        expect(record.votes.count).to be(1)
      end
    end

    context 'votes for his record' do
      let(:record) { FactoryBot.create(record_name, user: author) }

      before { login(author) }

      it 'add new vote for an answer' do
        expect { post :vote_for, params: { id: record }, format: :json }.to change(record.votes, :count).by(0)
      end
    end

  describe 'POST #vote_against' do
    let(:author) { FactoryBot.create(:user) }

    context 'votes against not for his record' do
      before { login(user) }

      let(:record) { FactoryBot.create(record_name, user: author) }

      it 'add new vote against record' do
        post :vote_against, params: { id: record }, format: :json
        expect(record.votes.count).to be(1)
        expect(record.votes.last.score).to be(-1)
      end

      it 'add new vote against record twice' do
        2.times { post :vote_against, params: { id: record }, format: :json }
        expect(record.votes.count).to be(1)
      end
    end

    context 'votes against his record' do
      let(:record) { FactoryBot.create(record_name, user: author) }

      before { login(author) }

      it 'add new vote against record' do
        expect { post :vote_against, params: { id: record }, format: :json }.to change(record.votes, :count).by(0)
      end
    end
  end

  describe 'DELETE #cancel_vote' do
    let(:record) { FactoryBot.create(record_name) }
    let!(:vote) { FactoryBot.create(:vote, voteable: record, user: user)}

    before { login(user) }

    it 'should destroy user vote' do
      delete :cancel_vote, params: { id: record }, format: :json

      expect(record.votes.count).to be 0
    end
  end
  end
end
