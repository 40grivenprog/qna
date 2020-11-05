require 'rails_helper'

shared_examples 'commented' do |record_name|
    describe 'POST #make_comment' do
    let(:resource) { FactoryBot.create(record_name, user: user) }

    before { login(user) }

    context 'user write a comment' do
      it 'added new comment for resource' do
        post :make_comment, params: { id: resource.id, comment: FactoryBot.attributes_for(:comment)}, format: :js
        expect(resource.comments.count). to be 1
      end
    end
  end
end
