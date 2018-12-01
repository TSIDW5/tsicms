class Discipline < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :code, presence: true, uniqueness: true
  validates :theoretical_classes, presence: true, numericality: { only_integer: true }
  validates :practical_classes, presence: true, numericality: { only_integer: true }
  validates :distance_classes, presence: true, numericality: { only_integer: true }
  validates :menu, presence: true
  validates :initials, presence: true, uniqueness: { case_sensitive: false }

  has_many :discipline_monitor_disciplines
  has_many :discipline_monitors, through: :discipline_monitor_disciplines

  belongs_to :period

  def self.workload
    self.sum()
  end

end
