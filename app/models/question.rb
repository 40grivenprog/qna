class Question < ApplicationRecord

  has_many :answers

  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 10 }

end
