class User < ApplicationRecord
  has_secure_password
  
  has_many :accounts, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
end
