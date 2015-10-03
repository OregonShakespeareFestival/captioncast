require 'charlock_holmes/string'
require_all 'lib/parsers/'

class DataFile < ActiveRecord::Base
  include Treat::Core::DSL

  @default_text_color = "#F7E694"

  def self.get_path(upload)
    file_name = upload[:data].original_filename
    directory = "public/data"
    return File.join(directory, file_name)
  end

  def self.save(upload)
    path = get_path(upload)
    File.open(path, "wb") { |f| f.write(upload[:data].read) }
  end

  def self.clean(upload)
    path = get_path(upload)
    File.delete(path)
  end

  def self.parse(upload, work_id, characters_per_line, split_type)
    # save file
    save(upload)
    # open saved file
    path = get_path(upload)
    encoding = File.read(path).detect_encoding[:encoding]
    file = File.read(path, :encoding => encoding)
    # get the work
    work = Work.find_by_id(work_id)
    # check the file extension and parse the file
    if File.extname(path) == ".txt"
      TXTParser.parse(file, work, characters_per_line, split_type)
    elsif File.extname(path) == ".rtf"
      RTFParser.parse(file, work, characters_per_line, split_type)
    elsif File.extname(path) == ".fdx"
      FDXParser.parse(file, work, characters_per_line, split_type)
    else
      return false
    end
    # save characters_per_line to work
    Work.find_by_id(work).update_attributes(:characters_per_line => characters_per_line)
    # parse ran succesfully
    clean(upload)
    return true
  end

end
