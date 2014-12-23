class Work < ActiveRecord::Base
  belongs_to :venue
  validates_presence_of :name
  validates_presence_of :venue_id

end
