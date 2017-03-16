class Project < ApplicationRecord
  belongs_to :user

  serialize :images, JSON
  mount_uploaders :images, PostImageUploader

  validates :user_id, presence: true
  validates :title,   presence: true, length: { maximum: 150 }
  validates :description, presence: true
end
