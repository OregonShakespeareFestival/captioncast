# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
   Works.create([{ name: 'Equivocation', venue: 'Bowmer' }])
  
   Texts.create([{ work: '3', sequence: '1', element: '2', content_text: 'The quick brown fox jumped over the lazy dog', visibility: 'true'}])

   Elements.create([{ type: 'spoken', text: 1, color: '#333333' }])
