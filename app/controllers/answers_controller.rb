class AnswersController < ApplicationController
  before_action :find_question, only: %i[index new create]
  before_action :find_answer, only: %i[show]

  def index
    @answers = @question.answers
  end

  def new
    @answer = @question.answers.new
  end

  def show
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @answer
    else
      render :new
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