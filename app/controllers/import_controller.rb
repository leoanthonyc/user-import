require 'csv'

class ImportController < ApplicationController
  def new
  end

  def show
  end

  def create
    file = import_params[:file]
    CSV.foreach(file.path, headers: true) do |row|
      User.create(row.to_hash)
    end
  end

  private

  def import_params
    params.permit(:file)
  end
end
