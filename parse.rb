require 'nokogiri'

f = File.open('script.fdx')
doc = Nokogiri::XML(f)
f.close

char1 = doc.xpath("//Character")[0]
puts char1
