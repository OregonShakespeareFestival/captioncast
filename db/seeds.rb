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
