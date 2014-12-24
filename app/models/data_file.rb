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
    nondialouge = doc.xpath("/FinalDraft/Content/*[not(@Type='Dialogue' or @Type='Character')]//Text")
      hnondialougue = Array.new

    nondialouge.each do |nondialouge|
      hnondialougue.push(nondialouge.to_str)
    end

    #XPath any sub-item of node type paragraph that has attribute character containing text.
    characters = doc.xpath("/FinalDraft/Content/Paragraph[@Type='Character']//Text")

    #Create a character hash
    hcharacters = Array.new

    #Push each elem to array
    characters.each do |character|
      hcharacters.push(character.to_str)
    end

    #Make sure only unique characters are in the array.
    hcharacters = hcharacters.uniq

    #XPath any sub-item of node type paragraph containing text.
    items = doc.xpath("/FinalDraft/Content/Paragraph//Text")

    #Counter int for the lines
    linenum = 0

    #Create a scope var to hold characters temporarily.

    linecharacter = ""

    #For each item let's bulding a string object with the line number and line.
    items.each do |item|
      #Cast our other itmes as strings.
      l = linenum.to_s
      s = item.to_str

      #Search the array to see if the line is actually a Character.
      charcheck = hcharacters.any? { |w| s =~ /^#{w}$/ }

      if charcheck == true
        linecharacter = s
        next
      else
        #If it's not a character better check to see if it's non-dialogue.
        nondial = hnondialougue.include?(s)
        if nondial == true
          txt = Text.create(sequence: linenum, content_text: linecharacter + ": " + s, visibility: false, element: Element.find_by(element_type: 'Dialogue'), work: Work.find_by_name('Equivocation'))
          txt.save
          linenum = linenum + 1
          next
        end
      end

      #If it's a new line let's go to the next item.
      if s == ("")
        next
      else
        linenum = linenum + 1
        text = l + " " + linecharacter + ": " + s
        txt = Text.create(sequence: linenum, content_text: linecharacter + ": " + s, visibility: true, element: Element.find_by(element_type: 'Dialogue'), work: Work.find_by_name('Equivocation'))
        txt.save
        #In final for all dialogue we should set visibility to true.
      end
    end
  end
end

