class AccountSnapshot < ApplicationRecord
  belongs_to :account
  
  validates :amount, presence: true, numericality: { only_integer: true }
  validates :recorded_at, presence: true
  
  scope :latest, -> { order(recorded_at: :desc).first }
  scope :recent, ->(limit = 10) { order(recorded_at: :desc).limit(limit) }
end
