# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
bowmer = Venue.find_or_create_by!(name: 'Angus Bowmer Theatre')
thomas = Venue.find_or_create_by!(name: 'Thomas Theatre')
lizzy  = Venue.find_or_create_by!(name: 'Allen Elizabethan Theatre')

equivocation = Work.find_or_create_by!(name: 'Equivocation') { |work| work.venue = bowmer }
  
