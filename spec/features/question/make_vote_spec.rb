require 'rails_helper'

feature 'User can vote if question is good and he has the same problem', %q{
  In order to show that question is popular
  As an authenticated user
  I'd like ot be able to vote for question
} do
  given(:author) { FactoryBot.create(:user) }
  given(:not_author) { FactoryBot.create(:user) }
  given!(:question) { FactoryBot.create(:question, user: author) }
  given(:vote_for) { FactoryBot.create(:vote, voteable: question, user: not_author)}
  given(:vote_against) { FactoryBot.create(:vote, voteable: question, user: not_author, score: -1)}

  describe 'Authenticated user', js: true  do
    describe 'votes for' do
      scenario 'for not his question' do
        sign_in(not_author)

        visit question_path(question)

        click_on id: "vote_for_question"

        within '.question_votes_result' do
          expect(page).to have_content(1)
        end
      end

      scenario 'for his question' do
        sign_in(author)

        visit question_path(question)

        click_on id: "vote_for_question"

        within '.question_votes_result' do
          expect(page).to have_content(0)
        end
      end

      scenario 'not his question twice' do
        vote_for

        sign_in(not_author)

        visit question_path(question)

        click_on id: "vote_for_question"

        within '.question_votes_result' do
          expect(page).to have_content(1)
        end
      end
    end

    describe 'votes against' do
      scenario 'not his question' do
        sign_in(not_author)

        visit question_path(question)

        click_on id: "vote_against_question"

        within '.question_votes_result' do
          expect(page).to have_content(-1)
        end
      end

      scenario 'his question' do
        sign_in(author)

        visit question_path(question)

        click_on id: "vote_against_question"

        within '.question_votes_result' do
          expect(page).to have_content(0)
        end
      end

      scenario 'not his question twice' do
        vote_against

        sign_in(not_author)

        visit question_path(question)

        click_on id: "vote_against_question"

        within '.question_votes_result' do
          expect(page).to have_content(-1)
        end
      end
    end

    describe 'cancel vote' do
      scenario 'for question' do
        vote_for

        sign_in(not_author)

        visit question_path(question)

        click_on id: "cancel_vote_question"

        within '.question_votes_result' do
          expect(page).to have_content(0)
        end
    end
    end
  end
end
