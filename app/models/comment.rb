class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article, polymorphic: true

  validates :body, presence: true, length: { maximum: 300 }

  after_create_commit { CommentRelayJob.perform_later(self, 'create') }
  after_update_commit { CommentRelayJob.perform_later(self, 'update') }
  after_destroy_commit { CommentDeleteJob.perform_later(self.id, self.article_id, self.article_type, self.user_id) }

  scope :ordered_by_most_recent,  -> { order(created_at: :desc) }
  scope :load_users_and_articles, -> { includes(:user, :article) }
end
