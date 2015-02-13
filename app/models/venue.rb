class Venue < ActiveRecord::Base
  validates_presence_of :name

  THOMAS_THEATRE = 'Thomas Theatre'
  ALLEN_ELIZABETHAN_THEATRE = 'Allen Elizabethan Theatre'
  ANGUS_BOWMER_THEATRE = 'Angus Bowmer Theatre'

  NAMES = [THOMAS_THEATRE, ALLEN_ELIZABETHAN_THEATRE, ANGUS_BOWMER_THEATRE]

  def self.thomas_theatre
    where(name: THOMAS_THEATRE).first_or_create
  end

  def self.allen_elizabethan_theatre
    where(name: ALLEN_ELIZABETHAN_THEATRE).first_or_create
  end

  def self.angus_bowmer_theatre
    where(name: ANGUS_BOWMER_THEATRE).first_or_create
  end

  def name_enum
    NAMES
  end
end
