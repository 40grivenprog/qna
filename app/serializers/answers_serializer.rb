class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :question_id, :user_id
end
