require 'nokogiri'

class DataFile < ActiveRecord::Base
  
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#uploads and saves the file
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  def self.save(upload)
    name =  upload['datafile'].original_filename
    directory = "public/data"
    #create the file path
    path = File.join(directory, name)
    #write the file


    #here we will check for .txt or .fdx

    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end


  #add element to the element table
  def self.add_element(name, type, color, work)
      #Text.create(sequence: linenum, content_text: linecharacter + ": " + s, visibility: true, element: Element.find_by(element_type: 'Dialogue'), work: Work.find_by_name('Equivocation'))
      e = Element.find_or_create_by!(element_name: name, element_type: type, color: color, work: Work.find_by_name(work))
      e.save
  end 
  

  #add the characters line to the Text table in the database
  #TODO: determin how to pass in the correct "work" elemnt
  def self.add_char_line(character, lineCount, charLine, visibility)
    txt = Text.create(sequence: lineCount, element: Element.find_by(element_name: character, element_type: 'CHARACTER'), work: Work.first, content_text: charLine, visibility: visibility)
    txt.save
  end


  #add the stage direction etc to the Text table in the database
  def self.add_direction(e_type, lineCount, direction, visibility)
    txt = Text.create(sequence: lineCount, element: Element.find_by(element_type: e_type), work: Work.first, content_text: direction, visibility: visibility)
    txt.save
    #puts "direction = " + e_type + " & " + direction 
    #puts lineCount
  end

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  #this is called in the controlers file when a file is uploaded
  # ** ONLY ACCEPTS .TXT OR .FDX FILES
  # .TXT file should be in the format
  # "CHARACTER NAME:" (all caps) "text goes here"
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  def self.parse_fd(upload,work)

    #create the file path abd open the file
    name =  upload['datafile'].original_filename
    directory = "public/data"
    path = File.join(directory, name)    
    f = File.open(path)

    if(File.extname(path) == ".txt")
      self.parse_text_file(f)
      return

    elsif(File.extname(path) == ".fdx")
      doc =  Nokogiri::XML(f)
      f.close
      self.parse_fdx(doc)
      return
    end   
  end



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  #used to parse a .txt file script (typically other languages)
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  def self.parse_text_file(f)

    #reads the file line by line into array
    arr = IO.readlines(f)


    #checks for character name in line and adds it to the elements table if it does not already exist
    arr.each do |line|
      name = line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil).match(/^[A-Z1-9\s]+(?=:)/)
      if (name != nil)
        #add the character "element" to the table if it does not exist
        self.add_element(name[0].upcase, "CHARACTER", "#666666", "LBJ")
      end
    end


    cur_line = ""
    haveline = false
    lineCount = 1
    name = ""


    #now we add the lines in the script to the database depending on the character
    arr.each do |line|

      #look for a character name indicating the beginning of a dialogue
      a = line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil).match(/^[A-Z1-9\s]+(?=:)/)
      
      #we have a completed monologue and need to submit it to the db
      if(a != nil and haveline == true)
        #here we send all the data to the database if its a dialogue
        self.add_char_line(name, lineCount, cur_line, true)
        puts name.upcase
        puts cur_line
        lineCount += 1
        haveline = false
        cur_line = ""
        name = ""
      end

      #we need to strip the name from the monologue 
      if (a != nil)
        #get the character speaking
        name = a[0].upcase
        #returns just the line said by the character
        cur_line = line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil).sub(/^[A-Z1-9\s]+:\s?/,"")
        haveline = true

      #we just append this line to our current characters script
      elsif (a == nil)
        cur_line += " " + line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil).sub(/^[A-Z1-9\s]+:\s?/,"")

        #add the character "element" to the table if it does not exist
        #self.add_element(name[0].upcase, "CHARACTER", "#666666", "LBJ")
      end
    end


  end



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  #used for parsing script in XML format
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  def self.parse_fdx(doc)
    #XML is like violence - if it doesn’t solve your problems, you are not using enough of it.
    #Build an xpath for what we want to search for
    #/FinalDraft/Content/Paragraph//Text
    #Nondialogue Elements
    nondialouge = doc.xpath("/FinalDraft/Content/*[not(@Type='Dialogue')]")

    #gets any non dialouge element
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
      #if its a character, get who and set character name
      if par_type.upcase == "CHARACTER"
        charName = line.children.children.text

      #gets the dialogue then we set the, character should alredy be set 
      elsif par_type.upcase == "DIALOGUE"
        charLine = line.children.children.text
        #here we send all the data to the database if its a dialogue
        self.add_char_line(charName.upcase, lineCount, charLine, true)
        #puts charName + " is saying " + charLine 
        lineCount += 1

      #gets visible parenthetical description 
      elsif par_type.upcase == "PARENTHETICAL"
        direction = line.children.children.text
        self.add_direction(par_type.upcase, lineCount, direction, true)
        #puts "WTF " + par_type.upcase + " " + direction
        lineCount += 1

      #catches non visible lines
      else
        direction = line.children.children.text
        self.add_direction(par_type.upcase, lineCount, direction, false)
        #puts "WTF " + par_type.upcase + " " + direction
        lineCount += 1
      end
    end
  end
end