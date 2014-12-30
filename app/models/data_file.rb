require 'nokogiri'

class DataFile < ActiveRecord::Base
  def self.save(upload)
    name =  upload['datafile'].original_filename
    directory = "public/data"
    #create the file path
    path = File.join(directory, name)
    #write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end


  #add element to the database
  def self.add_element(name, type, color, work)
      #Text.create(sequence: linenum, content_text: linecharacter + ": " + s, visibility: true, element: Element.find_by(element_type: 'Dialogue'), work: Work.find_by_name('Equivocation'))
      e = Element.find_or_create_by!(element_name: name, element_type: type, color: color, work: Work.find_by_name(work))
      e.save
  end 
  


  # get the characters in the play

  # get the name/title of the play

  # get the color of each character 



  def self.parse_fd(upload,work)

    name =  upload['datafile'].original_filename
    directory = "public/data"
    #create the file path

    path = File.join(directory, name)

    f = File.open(path)
    doc =  Nokogiri::XML(f)
    f.close

    #XML is like violence - if it doesn’t solve your problems, you are not using enough of it.
    #Build an xpath for what we want to search for
    #/FinalDraft/Content/Paragraph//Text
    #Nondialogue Elements
    nondialouge = doc.xpath("/FinalDraft/Content/*[not(@Type='Dialogue')]")
      #hnondialougue = Array.new


    #gets any non dialougge element
    nondialouge.each do |nondialouge|
      # assign and check each element
      type = nondialouge.attributes["Type"].value
      #add element to the database if not already there
      self.add_element("", type.to_str.upcase, "#666666", "Equivocation")
    end


    #XPath any sub-item of node type paragraph that has attribute character containing text.
    characters = doc.xpath("/FinalDraft/Content/Paragraph[@Type='Character']//Text")

    #Adds each character to the database if it's new to the database
    characters.each do |character|
      name = character.text.to_str.upcase
      self.add_element( name, "Character", "#111111", "Equivocation")
    
    end
  end
end

