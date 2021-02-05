module UploadedFilesHelper
  def get_filename(file)
    file.file.blob.filename
  end

  def get_content_type(file)
    file.file.blob.content_type
  end

  def get_file_count(files)
    if files.count.equal? 1
      '1 file'
    else
      "#{files.count} files"
    end
  end

  def image?(file)
    content_type = get_content_type(file)

    content_type.to_s.split('/').first == 'image'
  end

  def pdf?(file)
    get_content_type(file) == 'application/pdf'
  end
end
