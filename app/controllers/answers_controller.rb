class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :update]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[destroy update mark_as_best]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    if current_user.author_of? @answer
      @answer.update(answer_params)
    end
  end

  def destroy
    if current_user.author_of? @answer
      @answer.destroy
      flash[:notice] = 'Destroyed successfully'
    end
  end

  def mark_as_best
    @question = @answer.question

    @answer.mark_as_best if current_user.author_of? @question
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
