class Suggest < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  before_create :set_status

  delegate :name, to: :user, prefix: true

  validates :title, presence: true

  enum status: [:processing, :approved, :canceled]

  private
  def set_status
    self[:status] = :processing
  end
end
