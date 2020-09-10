class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[destroy]

  def create
    @answer = @question.answers.new(answer_params.merge(user_id: current_user.id))
    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def destroy
    question = @answer.question
    if current_user.author_of? @answer
      @answer.destroy
      redirect_to question, notice: 'Destroyed successfully'
    else
      redirect_to question, alert: 'You are not the author'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
