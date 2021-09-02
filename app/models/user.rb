class User < ApplicationRecord
  validates :name, presence: true
  validates :password, 
    presence: true, 
    length: { within: 10..16 }

  validate :password_must_contain_lowercase_character,
    :password_must_contain_uppercase_character,
    :password_must_contain_digit,
    :password_cant_have_three_consecutive_repeating_characters,
    if: -> { password.present? }

  private

  def password_must_contain_lowercase_character
    return if password.match(/[a-z]+/)
    errors.add(:password, "must contain at least one lowercase character")
  end

  def password_must_contain_uppercase_character
    return if password.match(/[A-Z]+/)
    errors.add(:password, "must contain at least one uppercase character")
  end

  def password_must_contain_digit
    return if password.match(/\d+/)
    errors.add(:password, "must contain at least one digit")
  end

  def password_cant_have_three_consecutive_repeating_characters
    return unless password.match(/([a-zA-Z0-9])\1\1+/)
    errors.add(:password, "must not contain three consecutive repeating characters")
  end
end
