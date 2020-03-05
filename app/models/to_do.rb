class ToDo < ApplicationRecord
  belongs_to :user
  belongs_to :trip

  validates :status, presence: true, inclusion: { in: %w(to-do in-progress done) }

  after_initialize :initial_status!

  def update_status(transition)
    if transition == 'traveling' && self.status == 'to-do'
      self.status = 'in-progress'
      return true
    elsif transition == 'arrived' && self.status == 'in-progress'
      self.status = 'done'
      return true
    elsif transition == 'cancel' && self.status != 'to-do'
      self.status = 'to-do'
      return true
    end
    return false
  end

  private

  def initial_status!
    self.status ||= 'to-do'
  end
end
