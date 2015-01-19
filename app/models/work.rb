class Work < ActiveRecord::Base
  belongs_to :venue
  validates_presence_of :work_name
  validates_presence_of :venue_id
  validates_presence_of :language

  def name
    work_name + ' - ' + language
  end

end
