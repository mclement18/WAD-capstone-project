class User < ApplicationRecord
  has_many :trips, -> { active }
  has_many :to_dos
  has_many :dreams, -> { where('status = ?', 'to-do') }, through: :to_dos, source: :trip
  has_many :travels, -> { where('status = ?', 'in-progress') }, through: :to_dos, source: :trip
  has_many :success, -> { where('status = ?', 'done') }, through: :to_dos, source: :trip
  has_many :comments
  
  has_secure_password

  validates :email, presence: true, uniqueness: true, email: true
  validates :role, inclusion: { in: %w(admin registered) }
  validates :deleted, inclusion: { in: [ true, false ] }

  after_initialize  :default_role!
  after_initialize  :initialize_deleted!
  before_validation :downcase_email

  scope :active,                     -> { where(deleted: false) }
  scope :load_associated_ressources, -> { includes(:trips, :dreams, :travels, :success, :comments) }

  mount_uploader :avatar, AvatarUploader

  paginates_per 6

  def soft_delete
    self.deleted = true
    self.email = "deleted#{SecureRandom.hex}@email.com"
    self.name = 'Deleted User'
    self.password = 'deleted'
    self.role = 'registered'
    self.remove_avatar!
    self.save
  end
  
  private

  def downcase_email
    self.email = email.downcase
  end

  def default_role!
    self.role ||= 'registered'
  end

  def initialize_deleted!
    self.deleted ||= false
  end
end
