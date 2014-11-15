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

items = doc.xpath("/FinalDraft/Content/Paragraph//Text")

linenum = 0

items.each do |item|
  l = linenum.to_s
  s = item.to_str

  if s == ("")
    next
  else
    puts item.type
    linenum = linenum + 1
    puts l + " " + s
  end
end
