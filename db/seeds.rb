# This file is used to "Seed" the database with the below values so they can be used in the interface

# Generally, this file should be used any time a new server is created or
# at the beginning of a season when the old plays need to be removed and the new ones need
# to be added.

# WHEN UPDATING A SEASON: You should only have to update the name of the "work_name", and the work.language. 
# in step 3 below. When this is run, it will automatically remove all old plays and their data from the database, and leave the
# application with the plays listed.  

# Step 1
# List any venues here that will be used this season.
# Existing venues will not be re-created if they already exist in the database
bowmer = Venue.find_or_create_by!(name: 'Angus Bowmer Theatre')
thomas = Venue.find_or_create_by!(name: 'Thomas Theatre')
lizzy  = Venue.find_or_create_by!(name: 'Allen Elizabethan Theatre')

# Step 2
# clean out any existing plays and their data
Text.delete_all 			#remove dialogue
Element.delete_all 			#remove characters
Work.delete_all 			#remove productions

# Step 3
# List all plays to be added to the database
Work.create!(work_name: "Twelfth Night") { |work| work.venue = bowmer; work.language = "en" }
Work.create!(work_name: "Great Expectations") { |work| work.venue = bowmer; work.language = "en" }
Work.create!(work_name: "The River Bride") { |work| work.venue = bowmer; work.language = "en" }
Work.create!(work_name: "The Yeomen of the Guard") { |work| work.venue = thomas; work.language = "en" }
Work.create!(work_name: "Vietgone") { |work| work.venue = thomas; work.language = "en" }

Work.create!(work_name: "Roe") { |work| work.venue = bowmer; work.language = "en" }
Work.create!(work_name: "Hamlet") { |work| work.venue = lizzy; work.language = "en" }
Work.create!(work_name: "The Wiz") { |work| work.venue = lizzy; work.language = "en" }

Work.create!(work_name: "The Winter’s Tale") { |work| work.venue = lizzy; work.language = "en" }
Work.create!(work_name: "Richard II") { |work| work.venue = lizzy; work.language = "en" }
Work.create!(work_name: "Timon of Athens") { |work| work.venue = bowmer; work.language = "en" }

Work.create!(work_name: "Twelfth Night") { |work| work.venue = bowmer; work.language = "es" }
Work.create!(work_name: "Great Expectations") { |work| work.venue = bowmer; work.language = "es" }
Work.create!(work_name: "The River Bride") { |work| work.venue = bowmer; work.language = "es" }
Work.create!(work_name: "The Yeomen of the Guard") { |work| work.venue = thomas; work.language = "es" }
Work.create!(work_name: "Vietgone") { |work| work.venue = thomas; work.language = "es" }

Work.create!(work_name: "Roe") { |work| work.venue = bowmer; work.language = "es" }
Work.create!(work_name: "Hamlet") { |work| work.venue = lizzy; work.language = "es" }
Work.create!(work_name: "The Wiz") { |work| work.venue = lizzy; work.language = "es" }

Work.create!(work_name: "The Winter’s Tale") { |work| work.venue = lizzy; work.language = "es" }
Work.create!(work_name: "Richard II") { |work| work.venue = lizzy; work.language = "es" }
Work.create!(work_name: "Timon of Athens") { |work| work.venue = bowmer; work.language = "es" }
