class Venue < ActiveRecord::Base
  validates_presence_of :name

  def name_enum
    ['Thomas Theatre', 'Allen Elizabethan Theatre', 'Angus Bowmer Theatre']
  end

end
