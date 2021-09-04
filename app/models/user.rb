class User < ApplicationRecord
  validates :name, presence: true
  validates :password, 
    presence: true, 
    length: { within: 10..16 }

  validate :password_complexity, if: -> { password.present? }

  PASSWORD_COMPLEXITY_RULES = {
    "must contain at least one lowercase character" => /[a-z]+/,
    "must contain at least one uppercase character" => /[A-Z]+/,
    "must contain at least one digit" => /\d+/,
    "must not contain three consecutive repeating characters" => /^(?:([a-zA-Z0-9])(?!\1\1+))*$/ }

  private

  def password_complexity
    PASSWORD_COMPLEXITY_RULES.each do |message, pattern|
      errors.add(:password, message) unless password.match(pattern)
    end
  end
end
