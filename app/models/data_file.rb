require 'nokogiri'

class DataFile < ActiveRecord::Base

  @default_text_color = "#F7E694"
  @work

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#uploads and saves the file
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  def self.save(upload)
    name =  upload['datafile'].original_filename
    directory = "public/data"
    #create the file path
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  #add element to the element table
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  

  def self.add_element(name, type, color, work_id)      
      e = Element.find_or_create_by!(element_name: name, element_type: type, color: color, work: @work)
      e.save
  end


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  #add the characters line to the Text table in the database
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  def self.add_char_line(character, lineCount, charLine, visibility, work_id)
    txt = Text.create(sequence: lineCount, element: Element.find_by(element_name: character, element_type: 'CHARACTER'), work: @work, content_text: charLine, visibility: visibility)
    txt.save
  end


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  #add the stage direction etc to the Text table in the database
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  def self.add_direction(e_type, lineCount, direction, visibility, work_id)
    txt = Text.create(sequence: lineCount, element: Element.find_by(element_type: e_type), work: @work, content_text: direction, visibility: visibility)
    txt.save
  end



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  #this is called in the controlers file when a file is uploaded
  # ** ONLY ACCEPTS .TXT OR .FDX FILES
  # .TXT file should be in the format
  # "CHARACTER NAME:" (all caps) "text goes here"
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  def self.parse_fd(upload, work)

    #create the file path abd open the file
    name =  upload['datafile'].original_filename
    directory = "public/data"
    path = File.join(directory, name)
    f = File.open(path)

    @work = Work.find_by_id(work)

    if(File.extname(path) == ".txt")
      self.parse_text_file(f, work)
      return

    elsif(File.extname(path) == ".fdx")
      doc =  Nokogiri::XML(f)
      f.close
      self.parse_fdx(doc, work)
      return
    end
  end



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  #used to parse a .txt file script (typically other languages)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  def self.parse_text_file(f, work)

    #reads the file line by line into array
    arr = IO.readlines(f)

    #adds all elements/character in the script to the database
    self.add_character_elements(arr, work)

    #add the lines in the script to the database depending on the character
    self.add_text_lines_to_db(arr, work)
  end



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  #used for parsing script in .fdx format
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  def self.parse_fdx(doc, work)
   
    #XPath for any Nondialogue Elements
    nondialouge = doc.xpath("/FinalDraft/Content/*[not(@Type='Dialogue')]")
    #add any nondialouge elemnts to the database
    self.add_fdx_nondialouge(nondialouge, work)


    #XPath for any characters.
    characters = doc.xpath("/FinalDraft/Content/Paragraph[@Type='Character']//Text")
    #add any nondialouge elemnts to the database
    self.add_fdx_character(characters, work)

    #add the lines to the database
    self.add_fdx_lines_to_db(doc, work)

  end



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#checks for character name in text file and adds it to the elements table if it does not already exist
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

def self.add_character_elements(arr, work)
    
    arr.each do |line|
      name = line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil).match(/^[A-Z1-9\s]+(?=:)/)
      if (name != nil)
        #add the character "element" to the table if it does not exist
        character_name = name[0].upcase.lstrip.rstrip
        self.add_element(character_name, "CHARACTER", @default_text_color, work)
      end
    end
end



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  #adds visible and non visible lines to database for FDX script
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  def self.add_fdx_lines_to_db(doc, work)

    #xpath through the whole document for generaing entire script
    lines = doc.xpath("/FinalDraft/Content/Paragraph")
    lineCount = 0
    charName = ""

    #loops through the script and adds necessary lines into the database
    lines.each do |line|
      par_type = line.attributes["Type"].value.lstrip.rstrip
      #if its a character, get who and set character name
      if par_type.upcase == "CHARACTER"
        charName = line.children.children.text
        charName = charName.lstrip.rstrip #strip leading and trailing whitespace from name

      #gets the dialogue, character should alredy be set
      elsif par_type.upcase == "DIALOGUE"
        charLine = line.children.children.text
        #here we send all the data to the database if its a dialogue
        self.add_char_line(charName.upcase, lineCount, charLine, true, work)
        lineCount += 1

      #gets parenthetical description (currently non-visible)
      elsif par_type.upcase == "PARENTHETICAL"
        direction = line.children.children.text
        self.add_direction(par_type.upcase, lineCount, direction, false, work)
        lineCount += 1

      #catches all other non visible lines
      else
        direction = line.children.children.text
        self.add_direction(par_type.upcase, lineCount, direction, false, work)
        lineCount += 1
      end
    end
  end


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  #adds character's lines the the database
  # - Takes an array which each index is a string/line from the script
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  def self.add_text_lines_to_db(arr, work)

    cur_line = ""
    haveline = false
    lineCount = 1
    name = ""

    arr.each do |line|

      #look for a character name indicating the beginning of a dialogue
      a = line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil).match(/^[A-Z1-9\s]+(?=:)/)

      #we have a completed monologue and need to submit it to the db
      if(a != nil and haveline == true)
        #here we send all the data to the database if its a dialogue
        self.add_char_line(name, lineCount, cur_line, true, work)
        lineCount += 1
        haveline = false
        cur_line = ""
        name = ""
      end

      #we need to strip the name from the monologue
      if (a != nil)
        #get the character speaking
        name = a[0].upcase.lstrip.rstrip
        #returns just the line said by the character (removing excess whitespace)
        cur_line = line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil).sub(/^[A-Z1-9\s]+:\s?/,"").squish
        haveline = true

      #we just append this line to our current characters script
      elsif (a == nil)
        cur_line += " " + line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil).sub(/^[A-Z1-9\s]+:\s?/,"").squish
      end
    end
  end


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#takes any nondialouge element from .fdx after xpath() and adds it to the db
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  def self.add_fdx_nondialouge(nondialouge, work)
      nondialouge.each do |nondialouge|
        type = nondialouge.attributes["Type"].value
        self.add_element("", type.to_str.upcase, @default_text_color, work)
    end
  end



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#takes any character element from .fdx after xpath() and adds it to the db
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  def self.add_fdx_character(characters, work)
      characters.each do |character|
        name = character.text.to_str.upcase.lstrip.rstrip
        self.add_element( name, "CHARACTER", @default_text_color, work)
    end
  end


end #end class
