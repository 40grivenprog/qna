class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at, :user_id, :files
  has_many :comments
  has_many :links, serializer: LinksSerializer
  def files
    object.files.map do |file|
      { url: rails_blob_url(file, only_path: true) }
    end
  end
end
