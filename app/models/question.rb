class Question < ApplicationRecord
  include Linkable
  include Attacheable
  include Voteable
  include Commentable

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_one :badge, dependent: :destroy

  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 10 }

  accepts_nested_attributes_for :badge, reject_if: :all_blank

  def best_answer
    answers.best_answer.first
  end
end
