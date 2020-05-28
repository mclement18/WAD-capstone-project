class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article, polymorphic: true

  validates :body, presence: true, length: { maximum: 300 }

  scope :ordered_by_most_recent,  -> { order(created_at: :desc) }
  scope :load_users_and_articles, -> { includes(:user, :article) }
end
