class QuestionsController < ApplicationController
  before_action :find_question, only: [:show, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    if @question.save
      redirect_to @question, notice: 'Your question succesfully created.'
    else
      render :new
    end
  end

  def destroy
    if current_user.authored_question? @question
      @question.destroy
      redirect_to questions_path, notice: 'Destroyed succesfully'
    else
      redirect_to questions_path, alert: 'You are not the author'
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
