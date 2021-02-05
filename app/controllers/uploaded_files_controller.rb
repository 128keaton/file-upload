class UploadedFilesController < ApplicationController
  include UploadedFilesHelper

  def index
    @files = UploadedFile.all
  end

  def show
    @file = UploadedFile.find(params[:id])
    add_breadcrumb(get_filename(@file))
  end

  def new
    @file = UploadedFile.new
    add_breadcrumb 'Upload File'
  end

  def create
    file = UploadedFile.create(create_params)
    redirect_to uploaded_file_path(file)
  end

  private

  def create_params
    params.require(:uploaded_file).permit(:file)
  end
end
