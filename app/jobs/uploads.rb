require 'charlock_holmes/string'

require_all 'lib/parsers/'

class Uploads < Resque::Job
  extend Resque::Plugins::Logger

  @queue = :uploads

  def self.perform(path, work_id, characters_per_line, split_type)
    # open saved file
    encoding = File.read(path).detect_encoding[:encoding]
    file = File.read(path, :encoding => encoding)
    # get the work
    work = Work.find_by_id(work_id)
    # check the file extension and parse the file
    begin
      if File.extname(path) == ".txt"
        txt_parser = TXTParser.new(work, characters_per_line, split_type)
        txt_parser.parse(file)
      elsif File.extname(path) == ".rtf"
        rtf_parser = RTFParser.new(work, characters_per_line, split_type)
        rtf_parser.parse(file)
      elsif File.extname(path) == ".fdx"
        fdx_parser = FDXParser.new(work, characters_per_line, split_type)
        fdx_parser.parse(file)
      else
        return false
      end
    rescue => error
      logger.info(error.message)
    end
    # save characters_per_line to work
    work.update_attributes(:uploading => false)
    # parse ran succesfully
    return true
  end

end
