class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def authored_question?(question)
    questions.include? question
  end

  def authored_answer?(answer)
  end
end
