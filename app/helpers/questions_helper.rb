module QuestionsHelper
  def subscription(question)
    current_user&.subscriptions&.find_by(question_id: question.id)
  end
end
