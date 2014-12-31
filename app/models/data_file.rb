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
  

  #add the data to the Text table in the database
  #def self.add_text(character, lineCount, charLine, visibility)
  #  txt = Text.find_or_create_by!(element: Work.find_by_name('CHARACTER'), work: Work.find_by_name('Equivocation'), content_text: charLine, visibility: true)
  #  txt.save
 # end



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

    #gets any non dialougge element
    nondialouge.each do |nondialouge|
      type = nondialouge.attributes["Type"].value
      #add element to the database if not already there
      self.add_element("", type.to_str.upcase, "#666666", "Equivocation")
    end

    #XPath any sub-item of node type paragraph that has attribute character containing text.
    characters = doc.xpath("/FinalDraft/Content/Paragraph[@Type='Character']//Text")

    #Adds each character element to the database if it's new to the database
    characters.each do |character|
      name = character.text.to_str.upcase
      self.add_element( name, "CHARACTER", "#111111", "Equivocation")
    end

    #xpath through the whole document for generaing entire script
    lines = doc.xpath("/FinalDraft/Content/Paragraph")
    lineCount = 0
    charName = ""

    #loops through the script and adds necessary lines into the database
    lines.each do |line|
      par_type = line.attributes["Type"].value
      #if its a character, get who and set character
      if par_type.upcase == "CHARACTER"
        charName = line.children.children.text

      #gets the dialogue then we set the, character should alredy be set 
      elsif par_type.upcase == "DIALOGUE"
        charLine = line.children.children.text
        #here we send all the data to the database if its a dialogue
        #self.add_text(charName, lineCount, charLine, true)
        puts charName + " is saying " + charLine


      #catches non visible 
      else
        #self.add_text(charName, lineCount, charLine, true)
        puts "WTF"

      #next line number 
      lineCount += 1
      end
    
    end

  end
end
