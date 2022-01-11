class User < ApplicationRecord
  before_save {self.email = email.downcase}

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
                    validates :department, length: {in: 2..30}, allow_blank: true
has_secure_password
  validates :pasword, presence: true, length: { minimum: 6 }, allow_nil: true
end
