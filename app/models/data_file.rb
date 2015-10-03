require 'charlock_holmes/string'

require_all 'lib/parsers/'

class DataFile

  def initialize(work, characters_per_line, split_type)
    @default_text_color = "#F7E694"
    @work = work
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
      txt_parser = TXTParser.new(@default_text_color, work_id, @characters_per_line, @split_type)
      txt_parser.parse(file)
    elsif File.extname(path) == ".rtf"
      rtf_parser = RTFParser.new(@default_text_color, work_id, @characters_per_line, @split_type)
      rtf_parser.parse(file)
    elsif File.extname(path) == ".fdx"
      fdx_parser = FDXParser.new(@default_text_color, work_id, @characters_per_line, @split_type)
      fdx_parser.parse(file)
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
