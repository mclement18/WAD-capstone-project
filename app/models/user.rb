class User < ApplicationRecord
  has_many :trips
  has_many :to_dos
  has_many :dreams, -> { where('status = ?', 'to-do') }, through: :to_dos, source: :trip
  has_many :travels, -> { where('status = ?', 'in-progress') }, through: :to_dos, source: :trip
  has_many :success, -> { where('status = ?', 'done') }, through: :to_dos, source: :trip
  
  has_secure_password

  validates :email, presence: true, uniqueness: true, email: true
  validates :role, inclusion: { in: %w(admin registered) }
  
  after_initialize :default_role!
  before_validation :downcase_email

  mount_uploader :avatar, AvatarUploader

  private

  def downcase_email
    self.email = email.downcase
  end

  def default_role!
    self.role ||= 'registered'
  end
end
