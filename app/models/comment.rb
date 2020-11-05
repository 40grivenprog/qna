class Comment < ApplicationRecord
  include Attacheable

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true
end
