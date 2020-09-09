class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def authored_question?(resource)
    questions.include? resource
  end

  def authored_answer?(resource)
    answers.include? resource
  end

end
