class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article, polymorphic: true

  validates :body, presence: true, length: { maximum: 300 }
end
