class Account < ApplicationRecord
  ACCOUNT_TYPES = %w[mufg rakuten_sec daiwa_sec other].freeze

  belongs_to :user
  has_many :account_snapshots, dependent: :destroy

  validates :account_type, presence: true, inclusion: { in: ACCOUNT_TYPES }

  def latest_snapshot
    account_snapshots.order(recorded_at: :desc).first
  end

  def latest_amount
    latest_snapshot&.amount || 0
  end
end
