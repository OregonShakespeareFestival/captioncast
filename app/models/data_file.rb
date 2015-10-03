require 'charlock_holmes/string'

require_all 'lib/parsers/'

class DataFile < ActiveRecord::Base

  def initialize(work, characters_per_line, split_type)
    @default_text_color = "#F7E694"
    @work= work
    @characters_per_line = characters_per_line
    @split_type = split_type
  end

  def parse(upload)
    # save file
    save(upload)
    # open saved file
    path = get_path(upload)
    encoding = File.read(path).detect_encoding[:encoding]
    file = File.read(path, :encoding => encoding)
    # get the work
    work_id = Work.find_by_id(@work)
    # check the file extension and parse the file
    if File.extname(path) == ".txt"
      TXTParser.parse(file, work_id, @characters_per_line, @split_type)
    elsif File.extname(path) == ".rtf"
      RTFParser.parse(file, work_id, @characters_per_line, @split_type)
    elsif File.extname(path) == ".fdx"
      FDXParser.parse(file, work_id, @characters_per_line, @split_type)
    else
      return false
    end
    # save characters_per_line to work
    Work.find_by_id(@work).update_attributes(:characters_per_line => @characters_per_line)
    # parse ran succesfully
    clean(upload)
    return true
  end

  private

  def get_path(upload)
    file_name = upload[:data].original_filename
    directory = "public/data"
    return File.join(directory, file_name)
  end

  def save(upload)
    path = get_path(upload)
    File.open(path, "wb") { |f| f.write(upload[:data].read) }
  end

  def clean(upload)
    path = get_path(upload)
    File.delete(path)
  end

end
