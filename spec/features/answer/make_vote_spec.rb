require 'rails_helper'

feature 'User can vote if answer was usefull for him', %q{
  In order to show that answer is usefull
  As an authenticated user
  I'd like ot be able to vote for answer
} do
  given(:author) { FactoryBot.create(:user) }
  given(:not_author) { FactoryBot.create(:user) }
  given(:question) { FactoryBot.create(:question)}
  given!(:answer) { FactoryBot.create(:answer, user: author, question: question) }
  given(:vote_for) { FactoryBot.create(:vote, voteable: answer, user: not_author)}
  given(:vote_against) { FactoryBot.create(:vote, voteable: answer, user: not_author, score: -1)}

  describe 'Authenticated user', js: true  do
    describe 'votes for' do
      scenario 'for not his answer' do
        sign_in(not_author)

        visit question_path(question)

        within '.answers' do
          click_on id: "vote_for_#{answer.id}_answer"

          within ".answer_#{answer.id}_votes_result" do
            expect(page).to have_content(1)
          end
        end
      end

      scenario 'for his answer' do
        sign_in(author)

        visit question_path(question)

        within '.answers' do
          click_on id: "vote_for_#{answer.id}_answer"

          within ".answer_#{answer.id}_votes_result" do
            expect(page).to have_content(0)
          end
        end
      end

      scenario 'for his answer twice' do
        vote_for

        sign_in(not_author)

        visit question_path(question)

        within '.answers' do
          click_on id: "vote_for_#{answer.id}_answer"

          within ".answer_#{answer.id}_votes_result" do
            expect(page).to have_content(1)
          end
        end
      end
    end

    describe 'votes against' do
      scenario 'not his answer' do
        sign_in(not_author)

        visit question_path(question)

        within '.answers' do
          click_on id: "vote_against_#{answer.id}_answer"

          within ".answer_#{answer.id}_votes_result" do
            expect(page).to have_content(-1)
          end
        end
      end

      scenario 'his answer' do
        sign_in(author)

        visit question_path(question)

        within '.answers' do
          click_on id: "vote_against_#{answer.id}_answer"

          within ".answer_#{answer.id}_votes_result" do
            expect(page).to have_content(0)
          end
        end
      end

      scenario 'against his answer twice' do
        vote_against

        sign_in(not_author)

        visit question_path(question)

        within '.answers' do
          click_on  id: "vote_against_#{answer.id}_answer"

          within ".answer_#{answer.id}_votes_result" do
            expect(page).to have_content(-1)
          end
        end
      end
    end

    describe 'cancel vote' do
      scenario 'for answer' do
        vote_for

        sign_in(not_author)

        visit question_path(question)

        within '.answers' do
          click_on id: "cancel_vote_#{answer.id}_answer"

          within ".answer_#{answer.id}_votes_result" do
            expect(page).to have_content(0)
          end
        end
      end
    end
  end
end
