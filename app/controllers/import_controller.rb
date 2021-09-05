class ImportController < ApplicationController
  def new
  end

  def show
  end

  def create
    result = User.import_csv(import_params[:file])
    flash[:import_notice] = result
    redirect_to import_path
  end

  private

  def import_params
    params.permit(:file)
  end
end
