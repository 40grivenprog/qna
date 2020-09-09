class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: %i[index new create]
  before_action :find_answer, only: %i[show destroy]

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
    @answer.user_id = current_user.id
    if @answer.save
      redirect_to @answer
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.authored_answer? @answer
      @answer.destroy
      redirect_to questions_path, notice: 'Destroyed succesfully'
    else
      redirect_to questions_path, alert: 'You are not the author'
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
