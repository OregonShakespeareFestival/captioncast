class Text < ActiveRecord::Base
  belongs_to :work
  belongs_to :element
  validates_presence_of :work_id
  validates_presence_of :element_id
  validates_presence_of :sequence
  #validates_presence_of :content_text
  #validates_presence_of :visibility
end
