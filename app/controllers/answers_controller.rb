class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[destroy update mark_as_best]
  after_action  :publish_answer, only: %i[create]

  authorize_resource

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
    flash[:notice] = 'Destroyed successfully'
  end

  def mark_as_best
    @question = @answer.question

    @answer.mark_as_best if current_user.author_of? @question
  end

  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast("answers_#{params[:question_id]}", {partial: ApplicationController.render( partial: 'answers/answer', locals: { answer: @answer, current_user: nil }),
                                            answer: @answer,
                                            question: @answer.question})
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
