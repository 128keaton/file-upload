module UploadedFilesHelper
  def get_filename(uploaded_file)
    uploaded_file.file.blob.filename
  end

  def get_content_type(uploaded_file)
    uploaded_file.file.blob.content_type
  end

  def get_file_count(uploaded_files)
    if uploaded_files.count.equal? 1
      '1 file'
    else
      "#{uploaded_files.count} files"
    end
  end

  def image?(uploaded_file)
    content_type = get_content_type(uploaded_file)

    content_type.to_s.split('/').first == 'image'
  end

  def pdf?(uploaded_file)
    get_content_type(uploaded_file) == 'application/pdf'
  end
end
