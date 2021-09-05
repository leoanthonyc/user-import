require 'csv'

class User::CsvImporter
  def initialize(file)
    @file = file
  end

  def call
    result = []
    CSV.foreach(@file.path, headers: true) do |row|
      user = User.new(row.to_hash)
      if user.save
        result << "#{user.name} was successfully saved"
      else
        non_password_related_errors = user.errors.reject { |error| error.attribute == :password }
        if non_password_related_errors.present?
          result << non_password_related_errors.map(&:full_message)
        elsif (required_changes = user.changes_until_valid_password)
          result << "Change #{required_changes} #{'character'.pluralize(required_changes)} of #{user.name} password"
        end
      end
    end
    result
  rescue CSV::MalformedCSVError
    raise "Invalid csv file"
  end
end
