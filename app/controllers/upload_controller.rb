class UploadController < ApplicationController
  def new
    play = Play.find_or_create_by(name: "The Counte Of Monte Cristo")
    play.save()
    script = create_document("script.fdx")
    parse_document(script)
  end

  def create_document(filename)
    f = File.open(filename)
    doc = Nokogiri::XML(f)
    f.close
    return doc
  end

  def parse_document(doc)
    doc.xpath("//Paragraph").each do |paragraph|
      paragraph.children.each do |child|
        #puts(child)
        if child.children != nil
          txt = Text.new(content_text: child.to_str)
          txt.save
        end
      end
    end
  end

end
