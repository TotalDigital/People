class FileUploader

  def initialize(io)
    @io = io
    write_file
  end

  def file
    File.open(file_path, 'r')
  end

  def file_path
    Rails.root.join('tmp', io.original_filename)
  end

  private

  def write_file
    File.open(file_path, 'wb') do |file|
      file.write(io.read)
    end
  end

  attr_accessor :io
end
