class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :find_question, only: [:show, :destroy, :update]
  before_action :authenticate_user!, except: [:index, :show]
  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
    gon.push({currentUser: current_user})
  end

  def show
    @answer = @question.answers.new
    @answer.links.new
    gon.push({currentUser: current_user})
    gon.push({question_id: @question.id})
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_badge
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question succesfully created.'
    else
      render :new
    end
  end

  def update
    binding.pry
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    message = 'Destroyed succesfully'
    redirect_to questions_path, notice: message
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions', {partial: ApplicationController.render( partial: 'questions/question', locals: { question: @question, current_user: nil }),
                                               question: @question})
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url, :done, :_destroy], badge_attributes: [:title, :image])
  end
end
