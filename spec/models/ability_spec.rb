require 'rails_helper'
require "cancan/matchers"

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    # it { should be_able_to :read, Answer }
    # it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { FactoryBot.create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { FactoryBot.create :user }
    let(:other) { FactoryBot.create :user }

    context 'question' do
      it { should_not be_able_to :manage, :all }
      it { should be_able_to :read, :all }

      it { should be_able_to :create, Question }

      it { should be_able_to [:make_comment], Question}

      it { should be_able_to [:vote_for, :vote_against, :cancel_vote], FactoryBot.create(:question, user: other) }
      it { should_not be_able_to [:vote_for, :vote_against, :cancel_vote], FactoryBot.create(:question, user: user) }

      it { should be_able_to :update, FactoryBot.create(:question, user: user) }
      it { should_not be_able_to :update, FactoryBot.create(:question, user: other) }

      it { should be_able_to :destroy, FactoryBot.create(:question, user: user) }
      it { should_not be_able_to :destroy, FactoryBot.create(:question, user: other) }
    end

    context 'answer' do
      let(:question) { FactoryBot.create(:question, user: user)}
      let(:other_user_question) { FactoryBot.create(:question, user: other)}

      it { should_not be_able_to :manage, :all }
      it { should be_able_to :read, :all }

      it { should be_able_to :create, Answer }

      it { should be_able_to [:make_comment], Answer }

      it { should be_able_to [:vote_for, :vote_against, :cancel_vote], FactoryBot.create(:answer, user: other) }
      it { should_not be_able_to [:vote_for, :vote_against, :cancel_vote], FactoryBot.create(:answer, user: user) }

      it { should be_able_to :update, FactoryBot.create(:answer, user: user) }
      it { should_not be_able_to :update, FactoryBot.create(:answer, user: other) }

      it { should be_able_to :destroy, FactoryBot.create(:answer, user: user) }
      it { should_not be_able_to :destroy, FactoryBot.create(:answer, user: other) }

      it { should be_able_to :mark_as_best, FactoryBot.create(:answer, question: question) }
      it { should_not be_able_to :mark_as_best, FactoryBot.create(:answer, question: other_user_question) }
    end

    context 'link' do
      let(:question) { FactoryBot.create(:question, user: user)}
      let(:other_user_question) { FactoryBot.create(:question, user: other)}

      it { should be_able_to :destroy,  FactoryBot.create(:link, linkable: question)}
      it { should_not be_able_to :destroy,  FactoryBot.create(:link, linkable: other_user_question)}
    end
  end
end
