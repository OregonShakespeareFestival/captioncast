#!/usr/bin/ruby

require 'nokogiri'

debug = ARGV[0]

#Open the Nokogiri File
f = File.open("Script.fdx")

#Create a Nokogiri Obeject out of the XML content
doc = Nokogiri::XML(f)

#Close the file
f.close

#If evaluates debug flag as string literal
if (debug == "1")
  puts doc
else
#Nothing here.
end

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

#If we're in debug print out all the characters
if (debug == "1")
  puts hcharacters
else
end

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
      #puts s
      next
    end
  end

  #If it's a new line let's go to the next item.
  if s == ("")
    next
  else
    linenum = linenum + 1
    puts l + " " + linecharacter + ": " + s

    #In final for all dialogue we should set visibility to true.
  end
end
