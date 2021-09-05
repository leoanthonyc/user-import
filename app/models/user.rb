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

  def self.import_csv(file)
    CsvImporter.new(file).call
  end

  def changes_until_valid_password
    validate
    password_errors = errors.where(:password)
    return 0 if password_errors.blank? 

    count = 0 
    password_errors.each do |error|
      if error.type == :too_short
        count += error.options[:count] - password.size 
        break
      elsif error.type == :too_long
        count += password.size - error.options[:count]
        break
      elsif error.type =~ /lowercase/
        count += 1
      elsif error.type =~ /uppercase/
        count += 1
      elsif error.type =~ /three consecutive repeating/
        password_dup = password.dup
        while (match = password_dup.match('(.)\1\1+'))
          matched = match[0]
          password_dup.gsub!(matched, matched[0..1] + matched[2].next + matched[3..-1])
          count += 1
        end
      end
    end
    count
  end

  private

  def password_complexity
    PASSWORD_COMPLEXITY_RULES.each do |message, pattern|
      errors.add(:password, message) unless password.match(pattern)
    end
  end
end
