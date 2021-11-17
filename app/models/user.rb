class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  before_save :downcase_email

  validates :name, presence: true,
    length: {maximum: Settings.length.digit_255}

  validates :email, presence: true,
    length: {maximum: Settings.length.digit_150},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}

  validates :password, presence: true,
    length: {minimum: Settings.length.digit_6}
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
