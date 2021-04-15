class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[index create]
  before_action :find_answer, only: %i[show update destroy]
  authorize_resource

  def index
    render json: @question.answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer, each_serializer: AnswerSerializer
  end

  def create
    answer = @question.answers.new(answer_params.merge(user: current_resource_owner))

    if answer.save
      render json: answer
    else
      render json: answer.errors
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: @answer.errors
    end
  end

  def destroy
    @answer.destroy
    render json: { message: 'Destroyed succesfully' }
  end

  private
  def answer_params
    params.require(:answer).permit(:body, links_attributes: [:name, :url])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
