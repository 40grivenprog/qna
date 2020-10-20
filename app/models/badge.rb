class Badge < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image

  validates :title, :image, presence: true
  validate :image_format

  def image_format
    if image.attached?
      errors[:base] << 'Wrong format' if !image.blob.content_type.starts_with?('image/')
    end
  end
end
