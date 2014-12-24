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

text   = Text.find_or_create_by!( content_text: 'Why me?') { |text| text.visibility = true; text.sequence = 1; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'It wasn’t that others weren’t considered.') { |text| text.visibility = true; text.sequence = 2; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'I can’t make the decision') { |text| text.visibility = true; text.sequence = 3; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'Why not?') { |text| text.visibility = true; text.sequence = 4; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'We’re a cooperative venture.') { |text| text.visibility = true; text.sequence = 5; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'Who’s in charge?') { |text| text.visibility = true; text.sequence = 6; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'We all share equally in the income and responsibilities of the theater...We’re a cooperative venture.') { |text| text.visibility = true; text.sequence = 7; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'Who’s in charge?') { |text| text.visibility = true; text.sequence = 7; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'Richard.') { |text| text.visibility = true; text.sequence = 8; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'This will take care of Richard...One week.') { |text| text.visibility = true; text.sequence = 9; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'One?') { |text| text.visibility = true; text.sequence = 10; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'He said/she said. Enter/exit. Drums/trumpets. How long can it take?') { |text| text.visibility = true; text.sequence = 11; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: ' You have one week to “dialogue” this.') { |text| text.visibility = true; text.sequence = 12; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'We’re already working on a new play.') { |text| text.visibility = true; text.sequence = 13; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'About?') { |text| text.visibility = true; text.sequence = 14; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'A king.') { |text| text.visibility = true; text.sequence = 15; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'How does he die?') { |text| text.visibility = true; text.sequence = 16; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'What makes you think he dies?') { |text| text.visibility = true; text.sequence = 17; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'You’ve killed more kings than any man alive. Your brain is a graveyard for royalty.') { |text| text.visibility = true; text.sequence = 18; text.work = equivocation; text.element = dialogue }
text   = Text.find_or_create_by!( content_text: 'This one dies of a broken heart.') { |text| text.visibility = true; text.sequence = 19; text.work = equivocation; text.element = dialogue }

