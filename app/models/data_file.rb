require 'nokogiri'
require 'treat'
require_all 'lib/parsers/'

class DataFile < ActiveRecord::Base
  include Treat::Core::DSL

  @default_text_color = "#F7E694"

  def self.getPath(upload)
    file_name = upload[:data].original_filename
    directory = "public/data"
    return File.join(directory, file_name)
  end

  def self.save(upload)
    path = getPath(upload)
    File.open(path, "wb") { |f| f.write(upload[:data].read) }
  end

  def self.clean(upload)
    path = getPath(upload)
    File.delete(path)
  end

  def self.parse(upload, work_id, characters_per_line, split_type)
    # save file
    save(upload)
    # open saved file
    path = getPath(upload)
    file = File.open(path)
    # get the work
    work = Work.find_by_id(work_id)
    # check the file extension and parse the file
    if File.extname(path) == ".txt"
      TXTParser.parse(file, work, characters_per_line, split_type)
    elsif File.extname(path) == ".rtf"
      RTFParser.parse(file, work, characters_per_line, split_type)
    elsif File.extname(path) == ".fdx"
      doc =  Nokogiri::XML(file)
      FDXParser.parse(doc, work, characters_per_line, split_type)
    else
      file.close
      return false
    end
    # save characters_per_line to work
    Work.find_by_id(work).update_attributes(:characters_per_line => characters_per_line)
    # parse ran succesfully
    file.close
    clean(upload)
    return true
  end

end
