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
  
dialogue = Element.find_or_create_by!(element_type: 'Dialogue') { |element| element.color = '#333333'; element.work = equivocation }
non_dialogue = Element.find_or_create_by!(element_type: 'Non-Dialogue') { |element| element.color = '#333333'; element.work = equivocation }
act_break = Element.find_or_create_by!(element_type: 'Act Break') { |element| element.color = '#333333'; element.work = equivocation }
scene_heading = Element.find_or_create_by!(element_type: 'Scene Heading') { |element| element.color = '#333333'; element.work = equivocation }
character = Element.find_or_create_by!(element_type: 'Character') { |element| element.color = '#333333'; element.work = equivocation }
action = Element.find_or_create_by!(element_type: 'Action') { |element| element.color = '#333333'; element.work = equivocation }
parenthetical = Element.find_or_create_by!(element_type: 'Parenthetical') { |element| element.color = '#333333'; element.work = equivocation }
operator_note = Element.find_or_create_by!(element_type: 'Operator Note') { |element| element.color = '#333333'; element.work = equivocation }
